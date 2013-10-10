module ArelHelpers
  extend ActiveSupport::Concern

  module ClassMethods
    private

    def issues
      Issue.arel_table
    end

    def journals
      Journal.arel_table
    end

    def jdetails
      JournalDetail.arel_table
    end

    def f_any
      Arel::Nodes::NamedFunction
    end

    def f_date(a)
      f_any.new("DATE", [a])
    end

    def f_count
      Arel::Nodes::Count
    end

    def literal(x)
      Arel::Nodes::SqlLiteral.new(x)
    end

    def count_all
      f_count.new([literal("*")])
    end

  end

end
