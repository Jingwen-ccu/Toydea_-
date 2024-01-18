require 'csv'

# 讀取 CSV 檔案
csv_file_path = 'r3-kenritsu-jidosho.the-best.csv'
csv_data = CSV.read(csv_file_path, headers: true)
csv_data.delete(0)

# 設定 txt 檔案
file_path = File.expand_path("2.txt")
file = File.open(file_path, "w")

# ソート順：利用回数(多い方が前) > 複本数(少ない方が前) > 出版時間(古い方が前)
sorted_data = csv_data.sort_by { |row| [-row[6].to_i, row[5].to_i, row[4], 
# > 作者(英語 A-Z > 50 音順 > 漢字はソートしなくて、後ろに置く)
                                        row[2].split.first] }
file.puts "順位, 資料名, 著者名, 出版者, 複本数, 利用回数"
sorted_data.each do |row|
    file.print row
end 
