module Where
  def where(conditions)
    query_result = []

    each do |record|
      conditions.each do |column_name, value|
        query_result << record if record[column_name] == value
      end
    end

    query_result
  end
end
