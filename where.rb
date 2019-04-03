module Where
  SQL_AND = /\s+and\s+/i
  OUTER_QUOTES = /\A["']|["']\Z/

  def where(conditions)
    query_results = []
    conditions = build_where(conditions) unless conditions.is_a?(Hash)

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
      template = conditions
      template = extract_column_names(template)

      template.map! do |column_name, value|
        [column_name.to_sym, value.gsub(OUTER_QUOTES, '')]
      end

      template.to_h
    when Array
      template = conditions.first
      values   = conditions[1..-1]
      template = extract_column_names(template)

      if values.first.is_a?(Hash)
        values = values.first

        template.each do |column_and_placeholder|
          column_and_placeholder[0] = column_and_placeholder[0].to_sym
          placeholder = column_and_placeholder[1].delete(':').to_sym
          column_and_placeholder[1] = values[placeholder]
        end
      else
        template.each do |column_and_placeholder|
          column_and_placeholder[0] = column_and_placeholder[0].to_sym
          column_and_placeholder[1] = values.shift
        end
      end

      template.to_h
    end
  end

  def extract_column_names(template)
    template = template.split(SQL_AND) if template.match(SQL_AND)

    [template].flatten.map do |condition|
      condition.split('=').map(&:strip)
    end
  end
end
