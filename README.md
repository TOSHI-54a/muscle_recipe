# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
現時点でのアイデアは以下のとおりです。
・機能
　AI又はAPIを使用した献立提案、冷蔵庫具材で作れる献立提案、栄養素計算、食事記録、近くのジム・公園検索、他ユーザーとのチャット、作った料理のシェア、同いいね機能、LINE通知、OAuth2認証
・使用する技術
docker,github,rails,redis,js,actioncable,devise
他に有用な技術があれば教えてください。
・できれば実装したい機能
マルチ検索、オートコンプリート
追加で環境の説明です。
ストレージはcloudflare r2 （又はAW3）、実行環境はfly.io、DBはPostgreSQLとします。