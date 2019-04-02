module Where
  def where(conditions)
    query_results = []

    each do |record|
      match = false

      conditions.each do |column_name, value|
        if value.is_a?(Regexp)
          match = record[column_name].match(value)
        else
          match = record[column_name] == value
        end

        break unless match
      end

      query_results << record if match
    end

    query_results
  end
end
