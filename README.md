# Baby_name-s

🌟累計2500pv&250uuを達成しました！

サービスのQiita記事は42LGTM,12000pv見ていただくことができました。https://qiita.com/Ryosuke-nakagawa/items/33d02034bcccdecaea86
## サービス概要

子供の名前が中々決まらない親が、
夫婦同士や、友達・祖父母と名前の候補をシェアして絞っていくことを補助する
名前候補のシェアアプリです。

## メインのターゲットユーザー

子供を妊娠した夫婦で生まれてくる子の名前を決めたいと思っている。
子供の名前は2人で納得する名前を決めたいと思っている。

## ユーザーが抱える課題

* 働いていて話し合いの場が十分に設けられず、中々候補が絞られていない。
* 名前の候補は上がっているが、整理できていない。
* お互いの名前に求める優先順位も違うので、どこを落とし所にするか迷っている。

## 解決方法

* 夫婦で名前候補をLINEアプリ上に残し、シェアしてアイデアを蓄積・整理していく。
* 姓名判断、響き、漢字など、優先順位を決めて評価、ソートできることで、どれが良いか考える手助けになる。

## なぜこのサービスを作りたいのか？

お薦めの名前を紹介してくれてアプリ上にメモしたり、姓名判断を検索したりするサービスはあるのですが、
夫婦で名前候補をシェアしたり、響き、姓名判断の結果、漢字の評価をまとめるようなアプリがなくて困った実体験からです。
また、メモするだけでなく姓名判断の結果を自動で取ってきてくれたり、それぞれの夫婦で評価軸が違うことを考慮したソート機能のあるアプリがあると、便利だと思ったからです。

## 使い方

|①トップページからLINE追加|②startをタップ|③ユーザーの初期設定|④メニューバーが変わって使用開始！|
|---|---|---|---|
|<img src="https://user-images.githubusercontent.com/88041615/179370549-cb57405b-f055-4e14-aac5-f68d6dc4c70a.png" width=210px height=350px>|<img src="https://user-images.githubusercontent.com/88041615/179370582-f0df277d-da9d-4ef7-9d07-c39d48114da1.png" width=210px height=350px >|<img src="https://user-images.githubusercontent.com/88041615/179370599-f100b363-ab4b-46a2-bc30-4a6abea5b315.png" width=210px height=350px >|<img src="https://user-images.githubusercontent.com/88041615/179370616-db810f81-fd41-4dec-9315-eda0837e992f.png" width=210px height=350px >

## 主な機能
|　　　名前の登録と姓名判断結果の自動登録　　　|　　　名前の評価の編集＆コメント機能　　　|
|---|---|
|　　　　<img src="https://user-images.githubusercontent.com/88041615/179371092-20c9e30d-b15a-47d9-8cd7-a5d33c7cb65a.gif" width=210px height=350px >　　|　　　<img src="https://user-images.githubusercontent.com/88041615/179371580-39b37514-4fd5-453a-8f82-ca29f8e094a9.gif" width=210px height=350px >　　　|
|LINEメッセージで名前を登録<br>姓名判断の結果をスクレイピングで取得&点数化|名前登録のCRUD&コメント登録のCRUD|

|各項目ごとの並び替え・お気に入り|  ユーザー同士でアカウントシェア機能  |通知機能|
|---|---|---|
|<img src="https://user-images.githubusercontent.com/88041615/179372537-36de03be-4e50-4099-a9b1-bbe440ef8946.gif" width=210px height=350px>|<img src="https://user-images.githubusercontent.com/88041615/180200066-53036c5c-9e2d-49f1-9f6c-35e7fdb4e3da.gif" width=210px height=350px>|<img src="https://user-images.githubusercontent.com/88041615/179372225-bf329dc7-939c-43b8-9c0e-008144e906a5.JPG" width=210px height=350px>|
|音の響き・姓名判断・漢字の評価ごとの並び替え・お気に入り機能|ユーザー同士で名前を保存・評価・コメントをする|アカウントシェアするとシェアした人が名前を登録するとメッセージが届く|

### 管理画面
各ユーザーの情報や登録した名前を確認・編集できる
### Twitter・Line拡散機能
### 20〇〇年のお名前ランキングページ

## 使用技術
### バックエンド
- Ruby(3.0.3)
- Ruby on Rails(6.1.4.1)
### Gem
- slim
- line-bot-api
- nokogiri
- meta-tags
- aws-sdk-s3
- dotenv-rails
- rails-i18n
- rubocop
- draper
- sitemap_generator
- gon
### フロント
- JavaScript
- jquery
- HTML
- CSS
- Bootstrap
- Font Awesome
- AdminLTE
### インフラ
- heroku
- PostgreSQL

## テーブル設計・ER図
[![Image from Gyazo](https://i.gyazo.com/2d8f696ec3cf6b2182a72a07c7d33490.png)](https://gyazo.com/2d8f696ec3cf6b2182a72a07c7d33490)
