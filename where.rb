module Where
  SQL_AND = /\s+and\s+/
  OUTER_QUOTES = /\A["']|["']\Z/

  def where(conditions)
    query_results = []

    # TODO: Handle SQL LIKE

    if conditions.is_a?(String)
      # If there are multiple conditions
      if conditions.match(SQL_AND)
        # Split on 'and'
        conditions = conditions.split(SQL_AND)
      end

      # Convert conditions into a two-dimensional array
      conditions = [conditions].flatten.map do |condition|
        condition.split('=').map(&:strip)
      end

      # Convert column_names to symbols
      conditions.map! do |column_name, value|
        [column_name.to_sym, value.gsub(OUTER_QUOTES, '')]
      end

      # Now they can be Hashified
      conditions = conditions.to_h
    end

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
end
