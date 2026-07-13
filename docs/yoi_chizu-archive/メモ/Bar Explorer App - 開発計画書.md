# 📋 プロジェクト概要

### 💡 開発目的

- カクテルバーやウイスキーバーの情報を地図上で簡単に探せるアプリケーション
- バーの特徴や雰囲気を直感的に把握できる
- 効率的なバー探しをサポート
- 複数条件での絞り込みを可能に

### 🤔 企画背景

- 現状は Google Maps と口コミ情報を個別に確認する必要がある
- バーの特徴（得意なお酒、雰囲気）が一目で分かりにくい
- 個人の訪問記録や感想を残す場所がない

### 🎯 差別化ポイント

- レスポンシブ対応による快適な操作性
- 複数条件での柔軟な検索機能
- 店舗情報の見やすい表示
- パフォーマンスを意識した実装

## 🗂 プロジェクト構成

### フォルダ構造

```
~/portfolio/
      └── yoino_chizuchou/         # プロジェクトルート
          ├── README.md         # プロジェクト説明
          ├── app/              # Railsアプリケーション
          └── db/
              └── data/         # 初期データ用フォルダ
                  ├── bars.csv      # 店舗基本情報
                  ├── specialties.csv  # お酒の種類情報
                  └── images/      # 店舗画像フォルダ

```

### データベース設計

### bars テーブル（店舗基本情報）

```ruby
create_table "bars", force: :cascade do |t|
  t.string   "name",           null: false    # 店舗名
  t.string   "address",        null: false    # 住所
  t.float    "latitude"                       # 緯度
  t.float    "longitude"                      # 経度
  t.string   "phone"                          # 電話番号
  t.string   "business_hours"                 # 営業時間
  t.string   "price_range"                    # 予算帯
  t.integer  "cover_charge"                   # チャージ料金
  t.string   "seat_type"                      # 席タイプ
  t.string   "smoking_status"                 # 喫煙状況
  t.boolean  "food_available"                 # フードの有無
  t.boolean  "soft_drinks"                    # ソフトドリンクの充実度
  t.text     "description"                    # 説明
  t.timestamps
end

```

### specialties テーブル（お酒の種類情報）

```ruby
create_table "specialties", force: :cascade do |t|
  t.references "bar",        null: false      # 店舗ID
  t.string     "category",   null: false      # カテゴリ
  t.boolean    "is_main"                      # メイン特徴フラグ
  t.text       "description"                  # 詳細説明
  t.timestamps
end

```

### photos テーブル（画像情報）

```ruby
create_table "photos", force: :cascade do |t|
  t.references "bar",        null: false      # 店舗ID
  t.string     "image"                        # 画像パス
  t.string     "category"                     # 画像カテゴリ
  t.timestamps
end

```

## 📅 開発フェーズ

### Phase 1: 基盤構築（3 週間）

### Week 1: 環境構築とデータ準備

1. **開発環境のセットアップ**
   - Ruby/Rails/PostgreSQL のインストール
   - GitHub リポジトリの作成
   - 開発環境の設定
2. **データの準備**
   - スプレッドシートでのデータ整理
   - CSV フォーマットの作成
   - 画像データの収集と整理
3. **基本的なモデル作成**
   - マイグレーションファイルの作成
   - モデル間の関連付け
   - バリデーション設定

### Week 2-3: 基本機能実装

1. **データインポート機能**
   - CSV インポートの Rake タスク作成
   - 画像アップロード機能の実装
   - Geocoder による位置情報取得
2. **基本的な CRUD 機能**
   - 店舗情報の表示
   - 一覧表示機能
   - 詳細表示機能

### Phase 2: 検索機能実装（4 週間）

### Week 1-2: 基本検索機能

1. **位置情報検索**
   - Google Maps API 導入
   - 現在地からの検索機能
   - 距離範囲指定機能
2. **フィルター機能**
   - お酒の種類による絞り込み
   - 価格帯による絞り込み
   - 席タイプ/喫煙状況での絞り込み

### Week 3-4: 検索機能の強化

1. **複合条件検索**
   - 複数条件の組み合わせ
   - 検索条件の保存機能
   - 検索履歴機能
2. **地図連携強化**
   - 地図からの範囲選択
   - 検索結果の地図表示
   - インタラクティブな操作

### Phase 3: UI/UX 改善（3 週間）

### Week 1: レスポンシブ対応

1. **レイアウト調整**
   - モバイル対応
   - タブレット対応
   - デスクトップ対応
2. **UI components**
   - 検索フォームの改善
   - 検索結果表示の最適化
   - 店舗カードのデザイン

### Week 2-3: パフォーマンス最適化

1. **表示の最適化**
   - 画像の最適化
   - レイジーローディング
   - キャッシュ戦略
2. **全体的な改善**
   - コードのリファクタリング
   - テストの追加
   - ドキュメントの整備

## 🛠 使用技術

### バックエンド

- Ruby 3.0.0
- Rails 6.1.3.2
- PostgreSQL

### フロントエンド

- TailwindCSS
- JavaScript
- Google Maps API

### インフラ

- GitHub
- AWS 予定（S3, EC2）

## ⚠️ 注意事項

1. データの追加は管理者のみが可能
2. 画像は著作権に注意
3. 店舗情報は定期的な更新が必要
4. パフォーマンスを常に意識

## 📌 次のステップ

1. プロジェクトフォルダの作成
2. GitHub リポジトリのセットアップ
3. 開発環境の構築
4. 1 店舗分のデータでテスト実装開始

---

※ この計画書は開発の進行に応じて適宜更新します。
