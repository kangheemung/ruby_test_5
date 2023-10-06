今週の課題内容
続いて次回までの課題ですが、お渡ししているCloud9の環境に以下ファイルを追加しました。

takeast:~/environment $ head -n 4*.csv 
id,comment,created_at,updated_at
1,test comment 1,2023-09-04 14:42:16 +0900,2023-09-04 14:42:16 +0900
2,test comment 2,2023-09-04 14:42:16 +0900,2023-09-04 14:42:16 +0900
3,test comment 3,2023-09-04 14:42:16 +0900,2023-09-04 14:42:16 +0900

全部で2000万行あります。実行後に以下のようになり、お渡ししているMySQLにインサートするようにしてみてください。

>  testinsertwithruby ruby insert.rb 
Finished inserting -1 rows
Insert time: 388.158969644 seconds
＝＝＝＝＝＝＝＝＝
RDSの存在確認

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

エンドポイント

*
username:*
password:*

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
Let's go!

insert.rb 作成　done
show databases;

データベース確認

+--------------------+
| Database           |
+--------------------+
| golang             |
| information_schema |
| lesson             |
| lessons            |
| mydatabase         |
| mysql              |
| performance_schema |
| post               |
| sys                |
+--------------------+
9 rows in set (0.01 sec)

まずデータベースを作る　＝W=
create database データベース名前;
create database inserts; <=コマンド

MySQL [(none)]> create database inserts;
Query OK, 1 row affected (0.01 sec)


MySQL [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| golang             |
| information_schema |
| inserts            |
| lesson             |
| lessons            |
| mydatabase         |
| mysql              |
| performance_schema |
| post               |
| sys                |
+--------------------+
10 rows in set (0.00 sec)
確認完了

  <=commend 実行
show tables;<=commend 実行

MySQL [(none)]> use inserts
Database changed
MySQL [inserts]> show tables;
Empty set (0.01 sec)

空なの確認

了解しました。MySQLにデータをインサートするためのテーブルを作成するためのSQL文を以下に示します。

```sql
CREATE TABLE inserts (
  id INT PRIMARY KEY,
  comment VARCHAR(255),
  created_at DATETIME,
  updated_at DATETIME
);
```

上記のSQL文を実行すると、`inserts`という名前のテーブルが作成されます。このテーブルは、4つのカラム（`id`、`comment`、`created_at`、`updated_at`）を持ち、それぞれのデータ型が指定されています。

データベース内でテーブルを作成するには、MySQLクライアント（例：phpMyAdmin、MySQLコマンドライン）を使用するか、プログラムから適切なクエリを実行してください。

もしテーブルが既に存在する場合、上記のクエリを実行するとエラーが発生します。その場合は、テーブルを削除してから再度作成するか、既存のテーブルにデータを追加することもできます。

ご不明な点があればお知らせください。
その後テーブル作りましょう。
CREATE TABLE inserts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    comment VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
実行

MySQL [inserts]> CREATE TABLE inserts (
    ->     id INT PRIMARY KEY AUTO_INCREMENT,
    ->     comment VARCHAR(255),
    ->     created_at DATETIME,
    ->     updated_at DATETIME
    -> ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
Query OK, 0 rows affected (0.02 sec)
テーブル作成完了。
MySQL [inserts]> show tables;
+-------------------+
| Tables_in_inserts |
+-------------------+
| inserts           |
+-------------------+
1 row in set (0.01 sec)

MySQL [inserts]> 

MySQL [inserts]> select * from inserts;
Empty set (0.00 sec)
中身確認した空である。
require 'csv'
require 'mysql2'

class Insert
  CLIENT = Mysql2::Client.new(
    host: '*',
    username: '*',
    password: '*',
    database: '*'
  )

  def self.insert_data(file_path)
    rows_inserted = 0 # rows_inserted の初期化

    CSV.foreach(file_path, headers: true) do |row|
      id = row['id']
      comment = row['comment']
      created_at = row['created_at']
      updated_at = row['updated_at']

      query = "INSERT INTO inserts (id, comment, created_at, updated_at) VALUES (?, ?, ?, ?)"
      statement = CLIENT.prepare(query)
      statement.execute(id, comment, created_at, updated_at)

      rows_inserted += 1
    end

    rows_inserted # rows_inserted を返す
  end
end

file_path = '/home/ec2-user/environment/*.csv'
rows_inserted = Insert.insert_data(file_path)
puts "Finished inserting #{rows_inserted} rows"
takeast:~/environment/kang_lesson $ ruby insert.rb
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
Finished inserting 231701 rows
| 231692 | test comment 231692 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231693 | test comment 231693 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231694 | test comment 231694 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231695 | test comment 231695 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231696 | test comment 231696 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231697 | test comment 231697 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231698 | test comment 231698 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231699 | test comment 231699 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231700 | test comment 231700 | 2023-09-04 14:42:18 | 2023-09-04 14:42:18 |
| 231701 | test comment 231701 | 2023-09-04 14:42:18 | NULL                |
+--------+---------------------+---------------------+---------------------+
231701 rows in set (0.14 sec)
インサート完了ぽい。。
インサート遅いので
データベース削除して再作成
もちろんです！データベースを削除するための基本的なコマンドは、以下の通りです。

1. データベースの一覧を表示するコマンド:
   ```sql
   SHOW DATABASES;
   ```

2. 特定のデータベースを選択するコマンド:
   ```sql
   USE データベース名;
   ```

3. 選択したデータベースを削除するコマンド:
   ```sql
   DROP DATABASE データベース名;
   ```

ただし、データベースを削除する前に、削除操作が正しいか確認してください。また、データベースのバックアップを取得しておくことを強くお勧めします。

もし具体的なデータベース管理システム（例：MySQL、PostgreSQL）を使用している場合や、操作対象のデータベースの種類や環境によって異なる手順がある場合は、追加情報を提供していただければ、より具体的な指示をお伝えできます。

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

```
mysql> select now(); select count(*) from inserts;
+---------------------+
| now()               |
+---------------------+
| 2023-10-02 07:58:30 |
+---------------------+
1 row in set (0.00 sec)

+----------+
| count(*) |
+----------+
|   805114 |
+----------+
1 row in set (0.04 sec)

mysql> select now(); select count(*) from inserts;
+---------------------+
| now()               |
+---------------------+
| 2023-10-02 07:58:31 |
+---------------------+
1 row in set (0.01 sec)

+----------+
| count(*) |
+----------+
|   805117 |
+----------+
1 row in set (0.04 sec)

mysql> 
```

1時間で80万件だとこのペースじゃ今日中に終わらないですね。
5時30分スタート
6時時点で

+----------+
| count(*) |
+----------+
|   459000 |
+----------+
1 row in set (0.04 sec)
あまり変わってない；；
1 row in set (0.00 sec)

+----------+
| count(*) |
+----------+
|   480000 |
+----------+
1 row in set (0.06 sec)7時14分
7時5分でスタート
MySQL [inserts]> select now(); select count(*) from inserts;
+---------------------+
| now()               |
+---------------------+
| 2023-10-02 10:13:45 |
+---------------------+
1 row in set (0.00 sec)

+----------+
| count(*) |
+----------+
|   410000 |
+----------+
1 row in set (0.04 sec)7時30分
+---------------------+
| now()               |
+---------------------+
| 2023-10-02 10:29:47 |
+---------------------+
1 row in set (0.00 sec)

+----------+
| count(*) |
+----------+
|  1080000 |
+----------+
1 row in set (0.08 sec)
少し早くなったぽい。。
けど10分ないではない。。
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
インサート遅くなる原因
ーバッチ処置
ーデータ移行
バルクインサート？
BULK insert
複数のinsert文を1にまとめる。
MYSQL限定CSVファイルをインポート出来る。

load data infileファイル名;
into table テープル名;
8時40分
8時42分はやい。。
+----------+
| count(*) |
+----------+
|  3700000 |
+----------+
1 row in set (0.44 sec)
待ってみましょう；
出来ました。。　＝W＝
takeast:~/environment/kang_lesson $ ruby insert.rb
Finished inserting 20000000 rows