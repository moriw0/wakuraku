## 💡 What is Wakuraku?
ワクワクするようなココロミをラクに楽しく開催・参加できるマッチングプラットフォームです。
<img width="698" alt="image" src="https://user-images.githubusercontent.com/87155363/214441954-1e6867b7-414d-4c8c-a362-930410b1362b.png">

## ✨ Purpose
誰しも挑戦したいことはあると思います。  
得意なことをワークショップとして開催したい。新たなココロミに挑戦したい。  
そんなあなたに寄り添います。

## 🔧 Function
* オーナー向け
  * イベント作成・編集
  * ダッシュボード管理
* ゲスト向け
  * イベント検索
  * イベント参加・キャンセル

## 🖥　Entity Relationship Diagram
<img width="390" alt="image" src="https://user-images.githubusercontent.com/87155363/214596559-5bf73129-8186-4299-825f-635067ce716f.png">


## 📌 Environment
* **フロントエンド**
    * HTML/CSS
    * Bootstrap
    * JavaScript
    * jQuery

* **バックエンド**
    * ruby 3.1.2
    * Ruby on Rails 6.1.7
    * PostgreSQL 14.6

* **インフラ・ツール**
    * Heroku（凍結中のためAWSへ移行予定）
    * Issues管理とGitHubFlowによる開発
    * RuboCopでコーディング規約を監視
    * RSpecでテストの自動化

* **使用したGem（抜粋）**

| Gem              | 用途 |
----|---- 
|devise            |ユーザーログイン機能 |
|omniauth-facebook |Facebookログイン機能 |
|discard           |論理削除対応 |
|searchkick        |Elasticsearchによる検索機能 |
|cocoon            |子レコード保存フォーム生成 |
|kaminari          |ページネーション対応 |
