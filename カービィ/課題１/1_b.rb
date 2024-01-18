require 'roo'

current_row_index = 0;
xlsx_path = 'matsuri_list.xlsx'
xlsx = Roo::Excelx.new(xlsx_path)
xlsx.default_sheet = xlsx.sheets.first

# 選擇要搜尋的列
column_index_to_search = 4
column_data = xlsx.column(column_index_to_search)
# 指定輸出的檔案路徑
column_data.each do |search_value|
    current_row_index+=1
    if current_row_index != 1
        output_file_path = File.expand_path("1_b_Result/#{search_value}.txt")
        #'a':繼續寫/'w':複寫
        File.open(output_file_path, 'a') do |file|
            if file.size.zero?
                file.puts "No, 都道府県, 名称"
            end
            file.puts xlsx.sheet(0).row(current_row_index).reject.with_index { |_, index| index == 3 }.join(', ')
        end
    end
end

