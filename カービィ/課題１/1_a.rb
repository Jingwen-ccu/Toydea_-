require 'roo'

#參數指向行
current_row_index = 0;
#要找的檔案
xlsx_path = 'matsuri_list.xlsx'
xlsx = Roo::Excelx.new(xlsx_path)
xlsx.default_sheet = xlsx.sheets.first

# 要搜尋的列
column_index_to_search = 2
column_data = xlsx.column(column_index_to_search)

column_data.each do |search_value|
    current_row_index+=1
    #排除第一行
    if current_row_index != 1
        #建立路徑
        output_file_path = File.expand_path("1_a_Result/#{search_value}.txt")
        File.open(output_file_path, 'a') do |file|
            #新開檔案的話
            if file.size.zero?
                file.puts "No, 名称, 開催月"
            end
            file.puts xlsx.sheet(0).row(current_row_index).reject.with_index { |_, index| index == 1 }.join(', ')
        end
    end
end

