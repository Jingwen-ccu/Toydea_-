require 'fileutils'
require 'rake'
require 'roo'
require 'roo-xls'
require 'csv'
require 'json'
#require 'axlsx'
require 'write_xlsx'

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
    puts "Processing Task: Matsuri..."
    Rake::Task[:processMatsuriMonth].invoke
    Rake::Task[:processMatsuriLocation].invoke 
    puts "Finish Task: Matsuri (1/3)"
  else
    puts "Can't find matsuri_list.xlsx"
  end

  #Task2
  if(isFileExist("r3-kenritsu-jidosho.the-best.csv"))
    puts "Processing Task: Books..."
    Rake::Task[:processBooks].invoke
    puts "Finish Task: Books (2/3)"
  else
    puts "Can't find r3-kenritsu-jidosho.the-best.csv"
  end

  #Task3
  if(isFileExist("GetAppList.txt"))
    puts "Processing Task: Apps..."
    Rake::Task[:processApps].invoke
    puts "Finish Task: Apps (3/3)"
  else
    puts "Can't find GetAppList.txt"
  end
 
  puts "Process finishing, Please check your Folder \"ProcessFiles\"."
end

#Task: Preprocess
task :Preprocess do

  #Delete old datas
  if(isDirExist("ProcessFiles"))
    newDirPath = File.join(Dir.getwd, "ProcessFiles");
    FileUtils.remove_dir(newDirPath, true)
  end

  #Create new Folder

  #Folder: ProcessFiles
  processFilesDirPath = File.join(Dir.getwd, "ProcessFiles");
  Dir.mkdir(processFilesDirPath)

  #Folder: ProcessFiles\Matsuri
  matsuriDirPath = File.join(Dir.getwd, "ProcessFiles\\Matsuri");
  Dir.mkdir(matsuriDirPath)
  Dir.chdir("ProcessFiles\\Matsuri")
  Dir.mkdir("Months")
  Dir.mkdir("Locations")
  Dir.chdir("..")
  Dir.chdir("..")

  booksDirPath = File.join(Dir.getwd, "ProcessFiles\\Books");
  Dir.mkdir(booksDirPath)

  sortAppsDirPath = File.join(Dir.getwd, "ProcessFiles\\Apps");
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

      #Output txt file
      if(isFileExist("ProcessFiles\\Matsuri\\Months\\#{curretRowData[3]}.txt"))
        File.open("#{monthsDirPath}\\#{curretRowData[3]}.txt", 'a') do |txtFile|
          txtFile.puts curretRowData.join(', ')
        end
      else
        File.open("#{monthsDirPath}\\#{curretRowData[3]}.txt", 'a') do |txtFile|
          txtFile.puts beginRowData.join(', ')
          txtFile.puts curretRowData.join(', ')
        end
      end

      #Output csv file
      if(isFileExist("ProcessFiles\\Matsuri\\Months\\#{curretRowData[3]}.csv"))
        File.open("#{monthsDirPath}\\#{curretRowData[3]}.csv", 'a') do |csvFile|
          # 写入BOM
          csvFile.write("\xEF\xBB\xBF")
          csvFile << (curretRowData).join(',') + " \n"
        end
      else
        File.open("#{monthsDirPath}\\#{curretRowData[3]}.csv", 'a') do |csvFile|
          # 写入BOM
          csvFile.write("\xEF\xBB\xBF")
          csvFile << (beginRowData).join(',') + " \n"
          csvFile << (curretRowData).join(',') + " \n"
        end
      end
    end
  

    #Output xlsx file: By copy csv contents
    allCSVFiles = Dir.entries(File.join("#{Dir.pwd}\\ProcessFiles\\Matsuri\\Months"))
    allCSVFiles = allCSVFiles.reject { |file| file == '.' || file == '..' || File.extname(file) == '.txt' || File.extname(file) == '.xlsx' }

    allCSVFiles.each do |csvFile|
      csvData = CSV.read("#{Dir.pwd}\\ProcessFiles\\Matsuri\\Months\\#{csvFile}")
      workbook = WriteXLSX.new("#{Dir.pwd}\\ProcessFiles\\Matsuri\\Months\\#{File.basename(csvFile, '.*')}.xlsx")
      worksheet = workbook.add_worksheet('Sheet 1')
      csvData.each_with_index do |row, row_index|
        row.each_with_index do |cell_value, col_index|
          worksheet.write(row_index, col_index, cell_value)
        end
      end
      # 關閉 Excel 檔案
      workbook.close
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
      
      #Output txt file
      if(isFileExist("ProcessFiles\\Matsuri\\Locations\\#{curretRowData[1]}.txt"))
        File.open("#{locationsDirPath}\\#{curretRowData[1]}.txt", 'a') do |txtFile|
          txtFile.puts curretRowData.join(', ')
        end
      else
        File.open("#{locationsDirPath}\\#{curretRowData[1]}.txt", 'a') do |txtFile|
          txtFile.puts beginRowData.join(', ')
          txtFile.puts curretRowData.join(', ')
        end
      end

      #Output csv file
      if(isFileExist("ProcessFiles\\Matsuri\\Locations\\#{curretRowData[1]}.csv"))
        File.open("#{locationsDirPath}\\#{curretRowData[1]}.csv", 'a') do |csvFile|
          # 写入BOM
          csvFile.write("\xEF\xBB\xBF")
          csvFile << (curretRowData).join(',') + " \n"
        end
      else
        File.open("#{locationsDirPath}\\#{curretRowData[1]}.csv", 'a') do |csvFile|
          # 写入BOM
          csvFile.write("\xEF\xBB\xBF")
          csvFile << (beginRowData).join(',') + " \n"
          csvFile << (curretRowData).join(',') + " \n"
        end
      end
    end

    #Output xlsx file: By copy csv contents
    allCSVFiles = Dir.entries(File.join("#{Dir.pwd}\\ProcessFiles\\Matsuri\\Locations"))
    allCSVFiles = allCSVFiles.reject { |file| file == '.' || file == '..' || File.extname(file) == '.txt' || File.extname(file) == '.xlsx' }

    allCSVFiles.each do |csvFile|
      csvData = CSV.read("#{Dir.pwd}\\ProcessFiles\\Matsuri\\Locations\\#{csvFile}")
      workbook = WriteXLSX.new("#{Dir.pwd}\\ProcessFiles\\Matsuri\\Locations\\#{File.basename(csvFile, '.*')}.xlsx")
      worksheet = workbook.add_worksheet('Sheet 1')
      csvData.each_with_index do |row, row_index|
        row.each_with_index do |cell_value, col_index|
          worksheet.write(row_index, col_index, cell_value)
        end
      end
      # 關閉 Excel 檔案
      workbook.close
    end
end

#Task:2
task :processBooks do
  
  #Copy
  bookCSV = CSV.read('r3-kenritsu-jidosho.the-best.csv', headers: :second_row)
  sortCSVPath = File.join(Dir.pwd, "ProcessFiles\\Books\\sortCSV.txt")
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

  #Sort data writing to TXT
  CSV.open(sortCSVPath, 'w') do |txtFile|
    sorted_data.each do |row|
      txtFile << row
    end
  end

  #Sort data writing to CSV
  File.open("#{File.join(Dir.pwd, "ProcessFiles\\Books\\sortCSV.csv")}", 'a') do |csvFile|
    # 写入BOM
    csvFile.write("\xEF\xBB\xBF")
    sorted_data.each do |row|
      csvFile << row
    end
  end

  #Sort data writing to xlsx
  #Output xlsx file: By copy csv contents
  File.open("#{File.join(Dir.pwd, "ProcessFiles\\Books\\sortCSV.csv")}", 'a') do |csvFile|
    csvData = CSV.read(csvFile)
    workbook = WriteXLSX.new("#{Dir.pwd}\\ProcessFiles\\Books\\sortCSV.xlsx")
    worksheet = workbook.add_worksheet('Sheet 1')
    csvData.each_with_index do |row, row_index|
      row.each_with_index do |cell_value, col_index|
        worksheet.write(row_index, col_index, cell_value)
      end
    end
    # 關閉 Excel 檔案
    workbook.close
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

  #Sort data writing to CSV
  File.open("#{File.join(Dir.pwd, "ProcessFiles\\Apps\\sortApps.csv")}", 'a') do |csvFile|
    workbook = WriteXLSX.new("#{Dir.pwd}\\ProcessFiles\\Apps\\sortApps.xlsx")
    worksheet = workbook.add_worksheet('Sheet 1')
    current_row = 1  # 初始化当前行


    sorted_data.each do |app|
      # 將每一筆資料寫入檔案
      csvFile.write("\xEF\xBB\xBF")
      csvFile.puts("App ID: #{app['appid']}, App Name: #{app['name']}, ")
    
      worksheet.write(0, 0, "\xEF\xBB\xBF")

      worksheet.write(current_row, 0, "App ID: #{app['appid']}")
      worksheet.write(current_row, 1, "App Name: #{app['name']}")

      current_row += 1

    end

    workbook.close
  end

end

task default: :ProcessAllTasks

  