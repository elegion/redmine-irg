module DataQueries
  extend ActiveSupport::Concern

  module ClassMethods
    private

    def execute
      q = yield
      ActiveRecord::Base.connection.execute(q.to_sql)
    end

    def created_results(project)
      execute { created_query(project) }
    end

    def with_status_results(project, status_ids)
      return [] if status_ids.blank?
      execute { with_status_query(project, status_ids) }
    end

    def created_query(project)
      issues
        .project(f_date(issues[:created_on]).as("d"))
        .project(count_all.as("c"))
        .where(issues[:project_id].eq(project.id))
        .group(:d)
        .order(:d)
    end

    def with_status_query(project, status_ids)
      q1 = with_status_by_journal_query(project, status_ids)
      q2 = with_status_on_creation_query(project, status_ids)
      q = q1.union(:all, q2)
      Arel::SelectManager.new(issues.engine)
        .from("#{q.to_sql} subquery")
        .project(f_date(literal("inner_date")).as("d"))
        .project(count_all.as("c"))
        .group(:d)
        .order(:d)
    end

    def with_status_by_journal_query(project, status_ids)
      issues
        .project(journals[:created_on].as("inner_date"))
        .join(journals, Arel::Nodes::InnerJoin)
          .on(journals[:journalized_id].eq(issues[:id]).and(journals[:journalized_type].eq(Issue.to_s)))
        .join(jdetails, Arel::Nodes::InnerJoin)
          .on(jdetails[:journal_id].eq(journals[:id]))
        .where(issues[:project_id].eq(project.id))
        .where(jdetails[:prop_key].eq(:status_id))
        .where(jdetails[:value].in(status_ids))
    end

    def with_status_on_creation_query(project, status_ids)
      issues
        .project(issues[:created_on].as("inner_date"))
        .join(journals, Arel::Nodes::OuterJoin)
          .on(journals[:journalized_id].eq(issues[:id]).and(journals[:journalized_type].eq(Issue.to_s)))
        .where(issues[:project_id].eq(project.id))
        .where(issues[:status_id].in(status_ids))
        .where(journals[:id].eq(nil).or(
          jdetails
            .project(jdetails[:id])
            .join(journals, Arel::Nodes::InnerJoin)
              .on(jdetails[:journal_id].eq(journals[:id]))
            .group(jdetails[:prop_key])
            .having(jdetails[:prop_key].eq(:status_id))
            .exists.not
        ))
    end

  end

end
