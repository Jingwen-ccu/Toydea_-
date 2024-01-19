require 'json'
require 'csv'

# 設定輸入
input_file_path = 'GetAppList.txt'
data = File.read(input_file_path)
# 設定輸出
output_file_path = File.expand_path("3_bonus.csv")
file = CSV.open(output_file_path, 'a')
file.to_io.write "\uFEFF"

# 將JSON轉換為Ruby數據結構
data = JSON.parse(data)

# 排序函式
def custom_sort(app)
    name = app['name'].downcase  # 忽略大小寫
    case name
    when ''
      [0, name, app['appid']]
    when /^[a-z]/
      [1, name, app['appid']]
    when /^\d/
      [2, name, app['appid']]
    when ' '
      [3, name, app['appid']]
    else
      [4, app['appid']]
    end
end

sorted_apps = data['applist']['apps'].sort_by(&method(:custom_sort))

sorted_apps.each do |app|
  file << app.values
end