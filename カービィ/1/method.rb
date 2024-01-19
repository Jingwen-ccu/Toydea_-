def process_data_and_write_to_csv(column_data, file_path, xlsx, 
    column_index_to_search, file_header)
    # 看第二列，一行一行往下看
    current_row_index = 0
    column_data.each do |search_value|
        # 紀錄目前行數
        current_row_index+=1
        # 排除第一行
        next if current_row_index == 1
        # 建立路徑
        output_file_path = File.join(file_path, "#{search_value}.csv")
        # 開檔案
        CSV.open(output_file_path, 'a') do |file|
            file.to_io.write "\uFEFF"
        # 新開檔案的話
            if CSV.read(output_file_path).count == 0 
                file << file_header
            end
            row_data = xlsx.sheet(0).row(current_row_index).reject.with_index { |_, index| index == 1 }
            file << row_data
        end
    end
end