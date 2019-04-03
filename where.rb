module Where
  SQL_AND = /\s+and\s+/
  OUTER_QUOTES = /\A["']|["']\Z/

  # TODO: Handle SQL LIKE
  def where(conditions)
    query_results = []

    conditions = build_where(conditions)

    each do |record|
      match = false

      conditions.each do |column_name, value|
        if value.is_a?(Regexp)
          match = record[column_name].match(value)
        else
          if record[column_name].is_a?(Integer)
            match = record[column_name] == value.to_i
          elsif record[column_name].is_a?(Float)
            match = record[column_name] == value.to_f
          else
            match = record[column_name] == value
          end
        end

        break unless match
      end

      query_results << record if match
    end

    query_results
  end

  def build_where(conditions)
    case conditions
    when String
      if conditions.match(SQL_AND)
        conditions = conditions.split(SQL_AND)
      end

      conditions = [conditions].flatten.map do |condition|
        condition.split('=').map(&:strip)
      end

      conditions.map! do |column_name, value|
        [column_name.to_sym, value.gsub(OUTER_QUOTES, '')]
      end

      conditions.to_h
    else
      conditions
    end
  end
end
