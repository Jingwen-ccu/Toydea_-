# 檢查是否提供了足夠的參數
if ARGV.length < 2
    puts "要給兩個檔案啦白癡"
    exit
end
require 'diffy'
# 提取兩個檔案的路徑
file_path1 = ARGV[0]
file_path2 = ARGV[1]
  
# 行數
count1 = File.foreach(file_path1).count
count2 = File.foreach(file_path2).count

# 讀取檔案內容
content1 = File.readlines(file_path1)
content2 = File.readlines(file_path2)

# 紀錄不同
def compare_a_b(file1, file2)
    diff = []
    file1.each_with_index do |line, index|
        diff << index + 1 if line != file2[index]
    end
    diff
end

# 比較行數
if count1 >= count2
    diff = compare_a_b(content1, content2)
else
    diff = compare_a_b(content2, content1)
end

# 比較兩個檔案的內容
if diff.empty?
    puts "完全一致"
else
    diff.each do |line_number|
      print "#{line_number} 行目が違う,"
      print "file1:#{content1[line_number - 1].chomp},"
      puts "fle2:#{content2[line_number - 1].chomp}"
    end
end
  