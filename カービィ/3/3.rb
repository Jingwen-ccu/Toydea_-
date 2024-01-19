require 'json'

file_path = 'GetAppList.txt'
data = File.read(file_path)
output_file_path = '3.txt'

# 將JSON轉換為Ruby數據結構
data = JSON.parse(data)

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
#File.write(output_file_path, JSON.pretty_generate('applist' => { 'apps' => sorted_apps }))

formatted_string = sorted_apps.map do |app|
    "appid: #{app['appid']}, name: #{app['name']}"
end.join("\n")
File.write(output_file_path, formatted_string) 
