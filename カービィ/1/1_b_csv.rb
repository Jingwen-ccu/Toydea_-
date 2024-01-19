require 'roo'
require 'csv'
require_relative 'method'

# 要找的檔案
xlsx_path = 'matsuri_list.xlsx'
xlsx = Roo::Excelx.new(xlsx_path)
xlsx.default_sheet = xlsx.sheets.first
# 要存的檔案
file_path = '1_b_Bonus'
# 要搜尋的列
column_index_to_search = 4
column_data = xlsx.column(column_index_to_search)
# 標題
file_header = ['No', '都道府県', '名称']

process_data_and_write_to_csv(column_data, file_path, xlsx, column_index_to_search, file_header)

