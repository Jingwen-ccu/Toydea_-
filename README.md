### データ説明

データを解析して、結果を　.txt ファイルで表示する

- matsuri_list.xlsx

  - 日本の祭りのデータ
  - 都道府県それぞれファイルを作って、開催する祭りと開催月を表示する
  - 開催月でファイルを作る。
  - 一行目: No, 都道府県, 名称, 開催月

- r3-kenritsu-jidosho.the-best.csv

  - 図書館の貸し出すデータ
  - データをソートする
    - ソート順：
      - 利用回数(多い方が前) > 複本数(少ない方が前) > 出版時間(古い方が前) > 作者(英語 A-Z > 50 音順 > 漢字はソートしなくて、後ろに置く)
  - 一行目: 順位, 資料名, 著者名, 出版者, 複本数, 利用回数
  - 「令和3年度本館図書館ベスト貸出児童書」はいらない

- GetAppList.txt

  - Steam のゲーム一覧
  - 名前と App Id を解析する
  - ソート順：名前 none > 英語 > 数字 > スペース > App Id
    - ソートできない文字はApp IdのみでOk
      - ソートできる文字タイプ
        - none
        - 英語 A (a) > B (b)
        - 数字 0 ~ 9
        - スペース
    
  - 出力見本： appid: 1821510, name:  A Space Odyssey
  ```
  AAA
  AA B
  AA 1
  AA市
  AA市 B
  ABCDD           appid: 9
  ABCDD           appid: 10
  ABCDD           appid: 11
  ABCDD           appid: 12
  ABCDD           appid: 13
  ABC市                appid: 1
  ABC件                appid: 2
  A1市町村市町村市町村市町村
  市町村市町村市町村市町村 appid: 16
  謎の謎の謎の謎の謎の    appid: 17
  ```



- 自分が出力したファイルをデータの位置に書いてください。

  - eq:
    - データ 1: guan/maturi_reuslt.txt

- データの位置
  - カービィ
    - データ 1: 
  - うどん
    - データ 1: udon/maturi_reuslt.txt
    - データ 2: udon/r3-kenritsu-jidosho.the-best.csv
    - データ 3: udon/GetAppList.txt
    - データ 4: udon/Gemfile
    - データ 5: udon/Gemfile
    - 説明書
      1. コードを実行します: rake
      2. すべての処理されたデータが配置される「ProcessFiles」フォルダーがあります。

- BONUS:
  - 出力ファイルをcsvファイルとして保存する
  - 出力ファイルをxlsファイルとして保存する
  - データの位置にあるファイルが完全一致にしているかの判定機能
    - eq: ruby compare.rb guan/maturi_reuslt.txt guan/maturi_reuslt2.txt
      - output: 完全一致 / success
      - output: 12 行目が違う, file1: .... file2: ....
  - 自動ですべてのファイルを比較する機能
    - eq: ruby auto_compare_all.rb