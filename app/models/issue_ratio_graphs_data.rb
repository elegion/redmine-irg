class IssueRatioGraphsData
  include ArelHelpers
  include ProcessingHelpers
  include DataQueries

  class << self

    def get_data(project, series)
      data = Hash[series.keys.map { |name| [name, send(name, project)] }]
      series.each_key { |k| series[k][:values] = normalize(data[k]) }
    end

    def resolved_ids
      Setting.plugin_redmine_irg["resolved_ids"].try(:map, &:to_i)
    end

    def closed_ids
      IssueStatus.where(is_closed: true).pluck(:id)
    end

    private

    def created(project)
      created_results(project)
    end

    def closed(project)
      with_status_results(project, closed_ids)
    end

    def resolved(project)
      with_status_results(project, resolved_ids)
    end

  end

end
