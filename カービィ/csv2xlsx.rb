require 'roo'
require 'write_xlsx'

def convert_csv_to_xlsx(input_csv_file, output_xlsx_file)
  # 載入CSV檔案
  csv_file = Roo::CSV.new(input_csv_file)

  # 創建新的XLSX檔案
  xlsx_file = WriteXLSX.new(output_xlsx_file)
  xlsx_page = xlsx_file.add_worksheet

  row_index = 0
  # 遍歷CSV檔案中的每一行，寫入到XLSX檔案中
  csv_file.each_with_index do |row, row_index|
    row.each_with_index do |value, col_index|
      xlsx_page.write(row_index, col_index, value)
    end
  end
  # 關閉XLSX檔案
  xlsx_file.close

  puts "轉換完成！"
end


def convert_csv_files_in_folder(input_folder, output_folder)
  # 获取输入文件夹内所有的 CSV 文件
  csv_files = Dir.glob(File.join(input_folder, '*.csv'))

  # 遍历每个 CSV 文件并进行转换
  csv_files.each do |csv_file|
    # 构建输出文件路径
    xlsx_file = File.join(output_folder, File.basename(csv_file, '.csv') + '.xlsx')

    # 调用转换函数
    convert_csv_to_xlsx(csv_file, xlsx_file)
  end
end