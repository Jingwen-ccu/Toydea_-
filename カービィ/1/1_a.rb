require 'roo'

#參數指向行
current_row_index = 0;
#要找的檔案
xlsx_path = 'matsuri_list.xlsx'
xlsx = Roo::Excelx.new(xlsx_path)
xlsx.default_sheet = xlsx.sheets.first
#要存的檔案
file_path = '1_a_Result'
# 要搜尋的列
column_index_to_search = 2
column_data = xlsx.column(column_index_to_search)

# 看第二列，一行一行往下看
column_data.each do |search_value|
    # 紀錄目前行數
    current_row_index+=1
    # 排除第一行
    next if current_row_index == 1
    # 建立路徑
    output_file_path = File.expand_path("#{file_path}/#{search_value}.txt")
    #開檔案
    File.open(output_file_path, 'a') do |file|
        # 新開檔案的話
        if file.size.zero?
            file.puts "No, 名称, 開催月"
        end
        file.puts xlsx.sheet(0).row(current_row_index).reject.with_index { |_, index| index == 1 }.join(', ')
    end
end

