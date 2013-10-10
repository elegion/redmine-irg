module ProcessingHelpers
  extend ActiveSupport::Concern

  module ClassMethods
    private

    def normalize(values)
      # On sqlite3 we get string instead of date, so we need this.
      to_time = ->(x) { x.respond_to?(:to_time) ? x.to_time : Time.parse(x) }
      # We can't use our aliases like `v['d']` and `v['c']` in MySQL, so we use
      # column indices instead.
      points = values.map { |v| { x: to_time.call(v[0]).to_i, y: v[1] } }
      points.reduce([{ y: 0 }]) { |acc, pt| acc.push({x: pt[:x], y: pt[:y] + acc.last[:y]}) }.drop(1)
    end

  end

end
