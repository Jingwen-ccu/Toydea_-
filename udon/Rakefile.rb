require 'fileutils'
require 'rake'
require 'roo'
require 'roo-xls'
require 'csv'
require 'json'

#check has file?
def isFileExist(file_name)
  file_path = File.join(Dir.pwd, file_name)
  File.exist?(file_path)
end

#check has Dir?
def isDirExist(dirName)
  Dir.exist?(dirName)
end

#Process Author's Name Weight
def processAuthorNameWeight(authorName)
  claenAuthor = authorName.split('／').first
  claenAuthor = claenAuthor.gsub(/\s+/, '')
  case
  when claenAuthor.match?(/[A-Za-z]+/) 
    [0, claenAuthor.downcase]  
  when notHasChinese(claenAuthor) 
    [2, claenAuthor]  
  when claenAuthor.match?(/[あ-んア-ン]+/)
    [1, claenAuthor] 
  else
    [3, claenAuthor] 
  end
end

#check not has Chinese
def notHasChinese(str)
  str = str.split('／').first
  str = str.gsub(/\s+/, '')
  str = str.gsub(/[A-Za-zあ-んア-ン]/, '')
  str.empty?
end

#Task: Do all tasks
task :ProcessAllTasks do
  puts "Processing all Tasks..."
  Rake::Task[:Preprocess].invoke

  #Task1-1
  #Task1-2
  if(isFileExist("matsuri_list.xlsx"))
    Rake::Task[:processMatsuriMonth].invoke
    Rake::Task[:processMatsuriLocation].invoke 
  else
    puts "Can't find matsuri_list.xlsx"
  end

  #Task2
  if(isFileExist("r3-kenritsu-jidosho.the-best.csv"))
    Rake::Task[:processBooks].invoke
  else
    puts "Can't find r3-kenritsu-jidosho.the-best.csv"
  end

  #Task3
  if(isFileExist("GetAppList.txt"))
    Rake::Task[:processApps].invoke
  else
    puts "Can't find GetAppList.txt"
  end
  
  puts "Process finishing, Please check your Folder \"ProcessFiles\"."
end

#Task: Preprocess
task :Preprocess do

  #Delete old datas
  if(isDirExist("ProcessFiles"))
    currentDir = Dir.getwd
    newDirPath = File.join(currentDir, "ProcessFiles");
    FileUtils.remove_dir(newDirPath, true)
  end

  #Create new Folder
  currentDir = Dir.getwd

  #Folder: ProcessFiles
  processFilesDirPath = File.join(currentDir, "ProcessFiles");
  Dir.mkdir(processFilesDirPath)

  #Folder: ProcessFiles\Matsuri
  matsuriDirPath = File.join(currentDir, "ProcessFiles\\Matsuri");
  Dir.mkdir(matsuriDirPath)
  Dir.chdir("ProcessFiles\\Matsuri")
  Dir.mkdir("Months")
  Dir.mkdir("Locations")
  Dir.chdir("..")
  Dir.chdir("..")

  booksDirPath = File.join(currentDir, "ProcessFiles\\Books");
  Dir.mkdir(booksDirPath)

  sortAppsDirPath = File.join(currentDir, "ProcessFiles\\Apps");
  Dir.mkdir(sortAppsDirPath)
end

#Task:1-1
task :processMatsuriMonth do
  #preprocess
    excel = Roo::Excelx.new("matsuri_list.xlsx")

  #check data
    totalRows = excel.sheet(0).last_row
    beginRowData = excel.sheet(0).row(1)
    monthsDirPath = File.join(Dir.pwd, "ProcessFiles\\Matsuri\\Months")
    (2..totalRows).each do |rowIndex|
      curretRowData = excel.sheet(0).row(rowIndex)
      filePath = File.join(monthsDirPath, curretRowData[3])
      if(isFileExist(filePath))
        File.open(filePath, 'a') do |txtFile|
          txtFile.puts curretRowData.join(', ')
        end
      else
        File.open(filePath, 'a') do |txtFile|
          txtFile.puts beginRowData.join(', ')
          txtFile.puts curretRowData.join(', ')
        end
      end
    end
end

#Task:1-2
task :processMatsuriLocation do
  #preprocess
    excel = Roo::Excelx.new("matsuri_list.xlsx")

  #check data
    totalRows = excel.sheet(0).last_row
    beginRowData = excel.sheet(0).row(1)
    locationsDirPath = File.join(Dir.pwd, "ProcessFiles\\Matsuri\\Locations")
    (2..totalRows).each do |rowIndex|
      curretRowData = excel.sheet(0).row(rowIndex)
      filePath = File.join(locationsDirPath, curretRowData[1])
      if(isFileExist(filePath))
        File.open(filePath, 'a') do |txtFile|
          txtFile.puts curretRowData.join(', ')
        end
      else
        File.open(filePath, 'a') do |txtFile|
          txtFile.puts beginRowData.join(', ')
          txtFile.puts curretRowData.join(', ')
        end
      end
    end
end

#Task:2
task :processBooks do
  
  #Copy
  bookCSV = CSV.read('r3-kenritsu-jidosho.the-best.csv', headers: :second_row)
  sortCSVPath = File.join(Dir.pwd, "ProcessFiles\\Books\\sortCSV")
  CSV.open(sortCSVPath, 'w') do |csv|
    bookCSV.each do |row|
      csv << row
    end
  end

  #Sorting
  sortCSV = CSV.read(sortCSVPath, headers: true)

  sorted_data = sortCSV.sort_by do |row|
  [
    -row["利用回数"].to_i,
    row["複本数"].to_i,
    row["出版年"], 
    processAuthorNameWeight(row["著者名"])
  ]
  end

  #Sort data writing
  CSV.open(sortCSVPath, 'w') do |csv|
    sorted_data.each do |row|
      csv << row
    end
  end
end

#Task:3
task :processApps do

  #Sort
  appPath = File.join(Dir.pwd, "GetAppList.txt");
  appData = File.read(appPath)
  appData = JSON.parse(appData)
  app_list = appData['applist']['apps']
  app_list.each do |app|
    app_id = app['appid']
    app_name = app['name']
    #puts "App ID: #{app_id}, App Name: #{app_name}"
  end

  sorted_data = app_list.sort_by do |app|
    app['name'].chars.each_with_index.map do |char, index|
      case char
      when /[A-Za-z]/
        [1, char.downcase]
      when /\d/
        [2, char.to_i]
      when /\s/
        [3, char]
      else
        [4, app['appid'].to_i]
      end
    end
  end

  sortApps = File.join(Dir.pwd, "ProcessFiles\\Apps\\sortApps.txt");
  File.open(sortApps, 'w') do |file|
    sorted_data.each do |app|
      # 將每一筆資料寫入檔案
      file.puts("App ID: #{app['appid']}, App Name: #{app['name']}")
    end
  end
end

task default: :ProcessAllTasks

  