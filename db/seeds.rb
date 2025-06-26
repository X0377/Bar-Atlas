unless Rails.env.production?
  Bar.destroy_all
  Specialty.destroy_all
end

bars_data = [
  # === 渋谷エリア ===
  {
    name: "Bar High Five",
    address: "東京都渋谷区道玄坂2-10-12",
    price_range: "¥3,000-5,000",
    smoking_status: "禁煙",
    description: "カクテルの種類が豊富で、バーテンダーのスキルが高い老舗バー。クラシックカクテルからオリジナルまで幅広く楽しめます。",
    phone: "03-1234-5678",
    business_hours: "18:00-02:00",
    image_url: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "渋谷横丁 赤提灯",
    address: "東京都渋谷区渋谷1-15-8",
    price_range: "¥2,000-3,500",
    smoking_status: "喫煙可",
    description: "昭和レトロな雰囲気の立ち飲みバー。リーズナブルな価格で日本酒と焼鳥が楽しめるアットホームな空間。",
    phone: "03-1111-2222",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "Rooftop Lounge SKY",
    address: "東京都渋谷区恵比寿2-8-11",
    price_range: "¥4,000-6,000",
    smoking_status: "禁煙",
    description: "都心の夜景を一望できるルーフトップバー。開放的な空間でシャンパンやカクテルを楽しめる大人の隠れ家です。",
    phone: "03-9012-3456",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "クラフトビア道玄坂",
    address: "東京都渋谷区道玄坂1-5-9",
    price_range: "¥2,500-4,000",
    smoking_status: "禁煙",
    description: "30種類以上のクラフトビールが楽しめるビアバー。ビール初心者から上級者まで満足できる品揃え。",
    phone: "03-2222-1111",
    business_hours: "16:00-23:30",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },

  # === 新宿エリア ===
  {
    name: "Whiskey Library",
    address: "東京都新宿区歌舞伎町1-5-3",
    price_range: "¥5,000-8,000",
    smoking_status: "喫煙可",
    description: "世界各国のウイスキーを300種類以上揃えたウイスキー専門バー。重厚で落ち着いた雰囲気の中でプレミアムウイスキーを堪能できます。",
    phone: "03-2345-6789",
    business_hours: "19:00-03:00",
    image_url: "https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "隠れ家バー 月光",
    address: "東京都新宿区ゴールデン街1-1-6",
    price_range: "¥3,000-6,000",
    smoking_status: "喫煙可",
    description: "ゴールデン街の奥にある知る人ぞ知る隠れ家的バー。マスターとの会話を楽しみながら、こだわりのカクテルを味わえます。",
    phone: "03-8901-2345",
    business_hours: "20:00-04:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "新宿サーモンズ",
    address: "東京都新宿区新宿3-18-4",
    price_range: "¥3,500-5,500",
    smoking_status: "分煙",
    description: "アイリッシュパブスタイルのバー。本格的なギネスビールと豊富なウイスキーセレクションが自慢。",
    phone: "03-3333-4444",
    business_hours: "17:30-02:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "歌舞伎町スカイバー",
    address: "東京都新宿区歌舞伎町2-45-7",
    price_range: "¥6,000-10,000",
    smoking_status: "禁煙",
    description: "35階から新宿の夜景を一望できる高級バー。プレミアムカクテルと絶景を楽しむ大人の社交場。",
    phone: "03-4444-5555",
    business_hours: "18:30-02:30",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },

  # === 六本木エリア ===
  {
    name: "Wine & Dine SAKURA",
    address: "東京都港区六本木6-12-2",
    price_range: "¥4,000-7,000",
    smoking_status: "分煙",
    description: "厳選されたワインと創作料理が楽しめるワインバー。エレガントで上質な空間で特別なひとときを過ごせます。",
    phone: "03-3456-7890",
    business_hours: "17:30-01:00",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "六本木ジャズクラブ",
    address: "東京都港区六本木4-8-15",
    price_range: "¥5,000-8,000",
    smoking_status: "禁煙",
    description: "生ジャズ演奏を聴きながらお酒が楽しめる本格ジャズクラブ。毎晩異なるアーティストの演奏を堪能できます。",
    phone: "03-5555-6666",
    business_hours: "19:00-03:00",
    image_url: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "ミッドタウンワインセラー",
    address: "東京都港区六本木9-7-1",
    price_range: "¥7,000-12,000",
    smoking_status: "禁煙",
    description: "世界最高峰のワインを揃えた高級ワインバー。ソムリエによる丁寧なワイン選びのアドバイスが受けられます。",
    phone: "03-6666-7777",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572788962817-4b3d7edbdde1?w=800&h=400&fit=crop&crop=center"
  },

  # === 銀座エリア ===
  {
    name: "Cocktail Laboratory",
    address: "東京都中央区銀座8-5-1",
    price_range: "¥6,000-10,000",
    smoking_status: "禁煙",
    description: "分子ガストロノミーを取り入れた革新的なカクテルが楽しめるモダンバー。洗練された空間で新感覚のドリンクを体験できます。",
    phone: "03-5678-9012",
    business_hours: "18:30-02:30",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "銀座クラシック",
    address: "東京都中央区銀座5-9-1",
    price_range: "¥8,000-15,000",
    smoking_status: "喫煙可",
    description: "銀座の老舗バーの代表格。格式高い雰囲気の中で、伝統的なバーテンディングの技を堪能できる名店。",
    phone: "03-7777-8888",
    business_hours: "18:00-02:00",
    image_url: "https://images.unsplash.com/photo-1553618541-51ca45ddbaea?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "ワインバー蔵人",
    address: "東京都中央区銀座3-4-17",
    price_range: "¥4,500-7,500",
    smoking_status: "分煙",
    description: "厳選された国産ワインと日本酒のペアリングが楽しめるユニークなバー。和食との相性も抜群。",
    phone: "03-8888-9999",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1572788962807-5fe8e13e41be?w=800&h=400&fit=crop&crop=center"
  },

  # === 赤坂エリア ===
  {
    name: "Piano Bar エレガンス",
    address: "東京都港区赤坂3-15-8",
    price_range: "¥5,000-8,000",
    smoking_status: "禁煙",
    description: "生演奏のジャズピアノとともに楽しむ上質なバータイム。大人の社交場として愛され続ける老舗ピアノバーです。",
    phone: "03-7890-1234",
    business_hours: "19:00-02:00",
    image_url: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "赤坂サントリーバー",
    address: "東京都港区赤坂4-2-9",
    price_range: "¥4,000-6,000",
    smoking_status: "分煙",
    description: "サントリーの銘酒を中心とした日本のウイスキーと焼酎が楽しめるバー。大人の隠れ家的存在。",
    phone: "03-9999-0000",
    business_hours: "18:00-01:30",
    image_url: "https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=800&h=400&fit=crop&crop=center"
  },

  # === 浅草エリア ===
  {
    name: "日本酒 蔵",
    address: "東京都台東区浅草1-20-5",
    price_range: "¥2,000-4,000",
    smoking_status: "禁煙",
    description: "全国各地の厳選日本酒と季節の和食が味わえる日本酒バー。和モダンで落ち着いた雰囲気が自慢です。",
    phone: "03-4567-8901",
    business_hours: "17:00-23:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "浅草ほっぴん",
    address: "東京都台東区浅草2-7-13",
    price_range: "¥1,800-3,000",
    smoking_status: "喫煙可",
    description: "下町情緒あふれる立ち飲みバー。常連さんとの会話を楽しみながら、リーズナブルにお酒が楽しめます。",
    phone: "03-0000-1111",
    business_hours: "16:30-23:30",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },

  # === 品川エリア ===
  {
    name: "Beer Garden TOKYO",
    address: "東京都品川区大崎1-11-1",
    price_range: "¥2,500-4,500",
    smoking_status: "屋外喫煙可",
    description: "屋上テラスで楽しむクラフトビールとBBQの組み合わせ。カジュアルで開放的な雰囲気で仲間との時間を満喫できます。",
    phone: "03-6789-0123",
    business_hours: "16:00-24:00",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "品川ステーションバー",
    address: "東京都港区高輪3-26-27",
    price_range: "¥3,000-5,000",
    smoking_status: "禁煙",
    description: "出張帰りのビジネスマンに人気のカジュアルバー。駅近で気軽に一杯飲めるアクセス抜群の立地。",
    phone: "03-1212-3434",
    business_hours: "17:00-01:00",
    image_url: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&h=400&fit=crop&crop=center"
  },

  # === 神田エリア ===
  {
    name: "和モダンバー 竹取",
    address: "東京都千代田区神田2-5-1",
    price_range: "¥3,500-5,500",
    smoking_status: "分煙",
    description: "日本の伝統とモダンが融合した和風バー。季節の食材を使ったオリジナルカクテルと和の趣が楽しめます。",
    phone: "03-0123-4567",
    business_hours: "18:00-01:30",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "神田サラリーマン横丁",
    address: "東京都千代田区神田須田町1-12",
    price_range: "¥2,000-3,500",
    smoking_status: "喫煙可",
    description: "昔ながらのサラリーマンの憩いの場。リーズナブルな価格で焼酎とおつまみが楽しめる庶民的なバー。",
    phone: "03-2345-5678",
    business_hours: "17:30-24:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },

  # === 恵比寿エリア ===
  {
    name: "恵比寿ワインセレクション",
    address: "東京都渋谷区恵比寿1-8-14",
    price_range: "¥4,000-7,000",
    smoking_status: "禁煙",
    description: "恵比寿駅から徒歩3分の好立地にあるワインバー。ソムリエ厳選のワインとチーズプレートが人気。",
    phone: "03-3456-6789",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "エビスビアホール",
    address: "東京都渋谷区恵比寿4-20-1",
    price_range: "¥2,800-4,200",
    smoking_status: "禁煙",
    description: "恵比寿ビール発祥の地で楽しむ本格ビアホール。新鮮なビールと本格ドイツ料理が味わえます。",
    phone: "03-4567-7890",
    business_hours: "16:30-23:00",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },

  # === 池袋エリア ===
  {
    name: "池袋ナイトオウル",
    address: "東京都豊島区南池袋1-28-2",
    price_range: "¥2,500-4,000",
    smoking_status: "喫煙可",
    description: "深夜まで営業している池袋の定番バー。カラオケも楽しめるエンターテイメント性の高い空間。",
    phone: "03-5678-8901",
    business_hours: "19:00-05:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "カクテルファクトリー池袋",
    address: "東京都豊島区西池袋1-21-1",
    price_range: "¥3,000-5,000",
    smoking_status: "禁煙",
    description: "若い世代に人気のモダンカクテルバー。SNS映えするオリジナルカクテルとスタイリッシュな空間が魅力。",
    phone: "03-6789-9012",
    business_hours: "18:30-02:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },

  # === 表参道エリア ===
  {
    name: "表参道ヒルズバー",
    address: "東京都港区北青山3-6-1",
    price_range: "¥5,000-8,000",
    smoking_status: "禁煙",
    description: "表参道ヒルズ内の洗練されたバー。ファッション感度の高い大人が集う上質なカクテルラウンジ。",
    phone: "03-7890-0123",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },

  # === 下北沢エリア ===
  {
    name: "下北クラフトサワー",
    address: "東京都世田谷区北沢2-26-5",
    price_range: "¥2,200-3,800",
    smoking_status: "禁煙",
    description: "下北沢らしいサブカル感のあるバー。手作りサワーとクラフトチューハイが若者に大人気。",
    phone: "03-8901-1234",
    business_hours: "17:00-02:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },

  # === 中野エリア ===
  {
    name: "中野ブロードウェイバー",
    address: "東京都中野区中野5-52-15",
    price_range: "¥2,000-3,500",
    smoking_status: "喫煙可",
    description: "アニメとサブカルの聖地・中野の隠れ家バー。オタク文化に理解のあるマスターとの会話も楽しい。",
    phone: "03-9012-2345",
    business_hours: "19:00-03:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },

  # === 吉祥寺エリア ===
  {
    name: "ハーモニカ横丁 音楽酒場",
    address: "東京都武蔵野市吉祥寺本町1-1-8",
    price_range: "¥1,800-3,200",
    smoking_status: "喫煙可",
    description: "吉祥寺名物ハーモニカ横丁の老舗酒場。ジャズが流れる中で地酒と手作りおつまみが楽しめる。",
    phone: "03-0123-3456",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=400&fit=crop&crop=center"
  },

  # === 上野エリア ===
  {
    name: "上野アメ横酒場",
    address: "東京都台東区上野4-9-14",
    price_range: "¥1,500-2,800",
    smoking_status: "喫煙可",
    description: "アメ横の活気ある雰囲気の中で楽しむ立ち飲みバー。観光客から地元民まで多くの人で賑わう名物店。",
    phone: "03-1234-4567",
    business_hours: "15:00-23:00",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },

  # === 秋葉原エリア ===
  {
    name: "電気街カクテルバー",
    address: "東京都千代田区外神田3-1-16",
    price_range: "¥2,800-4,500",
    smoking_status: "禁煙",
    description: "電子機器をモチーフにしたユニークなカクテルが楽しめる秋葉原らしいテーマバー。メイドカフェとは一味違う大人の空間。",
    phone: "03-2345-5678",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },

  # === 築地エリア ===
  {
    name: "築地市場酒場",
    address: "東京都中央区築地4-14-15",
    price_range: "¥2,200-3,800",
    smoking_status: "分煙",
    description: "築地市場の新鮮な魚介類とお酒が楽しめる本格的な海鮮酒場。朝から営業している珍しいバー。",
    phone: "03-3456-6789",
    business_hours: "6:00-14:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },

  # === 有楽町エリア ===
  {
    name: "有楽町ガード下酒場",
    address: "東京都千代田区有楽町2-1-10",
    price_range: "¥2,000-3,500",
    smoking_status: "喫煙可",
    description: "昭和の風情が残るガード下の老舗酒場。サラリーマンの憩いの場として長年愛され続ける名店。",
    phone: "03-4567-7890",
    business_hours: "16:00-23:30",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },

  # === 高級バー追加 ===
  {
    name: "プレミアムラウンジ麻布",
    address: "東京都港区麻布十番2-3-5",
    price_range: "¥8,000-15,000",
    smoking_status: "禁煙",
    description: "麻布十番の高級会員制ラウンジ。世界最高峰のスピリッツとプライベート感溢れる上質な空間を提供。",
    phone: "03-5678-8901",
    business_hours: "19:00-03:00",
    image_url: "https://images.unsplash.com/photo-1553618541-51ca45ddbaea?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "ザ・リッツバー",
    address: "東京都港区赤坂9-7-1",
    price_range: "¥10,000-20,000",
    smoking_status: "禁煙",
    description: "5つ星ホテル内の最高級バー。一流バーテンダーによる芸術的なカクテルと非日常的な体験を提供。",
    phone: "03-6789-9012",
    business_hours: "17:00-02:00",
    image_url: "https://images.unsplash.com/photo-1572788962817-4b3d7edbdde1?w=800&h=400&fit=crop&crop=center"
  }
]

puts "充実したバーのサンプルデータを作成中..."

bars_data.each_with_index do |bar_data, index|
  bar = Bar.create!(bar_data)
  puts "[#{index + 1}/#{bars_data.length}] 作成完了: #{bar.name} (#{bar.address.split('区')[1]&.split('1')&.first || bar.address.split('区')[0].split('都')[1]}エリア)"
end

# スペシャリティデータの大幅拡充
specialties_data = [
  # 渋谷エリア
  { bar: Bar.find_by(name: "Bar High Five"), category: "カクテル", is_main: true, description: "クラシックカクテルからオリジナルまで150種類" },
  { bar: Bar.find_by(name: "Bar High Five"), category: "ウイスキー", is_main: false, description: "スコッチ、バーボンを中心に80種類" },

  { bar: Bar.find_by(name: "渋谷横丁 赤提灯"), category: "日本酒", is_main: true, description: "全国の地酒を常時30種類以上" },
  { bar: Bar.find_by(name: "渋谷横丁 赤提灯"), category: "焼酎", is_main: false, description: "芋・麦・米焼酎各種" },

  { bar: Bar.find_by(name: "Rooftop Lounge SKY"), category: "カクテル", is_main: true, description: "夜景とともに楽しむシャンパンカクテル" },
  { bar: Bar.find_by(name: "Rooftop Lounge SKY"), category: "ワイン", is_main: false, description: "スパークリングワイン各種" },

  { bar: Bar.find_by(name: "クラフトビア道玄坂"), category: "ビール", is_main: true, description: "国内外のクラフトビール30種類以上" },

  # 新宿エリア
  { bar: Bar.find_by(name: "Whiskey Library"), category: "ウイスキー", is_main: true, description: "世界中のウイスキー300種類以上" },
  { bar: Bar.find_by(name: "Whiskey Library"), category: "カクテル", is_main: false, description: "ウイスキーベースカクテル" },

  { bar: Bar.find_by(name: "隠れ家バー 月光"), category: "日本酒", is_main: true, description: "厳選された地酒" },
  { bar: Bar.find_by(name: "隠れ家バー 月光"), category: "カクテル", is_main: false, description: "和のテイストを活かしたオリジナルカクテル" },

  { bar: Bar.find_by(name: "新宿サーモンズ"), category: "ビール", is_main: true, description: "本格アイリッシュビールとエール" },
  { bar: Bar.find_by(name: "新宿サーモンズ"), category: "ウイスキー", is_main: false, description: "アイリッシュウイスキー各種" },

  { bar: Bar.find_by(name: "歌舞伎町スカイバー"), category: "カクテル", is_main: true, description: "プレミアムスピリッツを使用した創作カクテル" },
  { bar: Bar.find_by(name: "歌舞伎町スカイバー"), category: "シャンパン", is_main: false, description: "世界の高級シャンパン" },

  # 六本木エリア
  { bar: Bar.find_by(name: "Wine & Dine SAKURA"), category: "ワイン", is_main: true, description: "フランス、イタリア産を中心とした厳選ワイン" },
  { bar: Bar.find_by(name: "Wine & Dine SAKURA"), category: "カクテル", is_main: false, description: "ワインベースカクテル" },

  { bar: Bar.find_by(name: "六本木ジャズクラブ"), category: "カクテル", is_main: true, description: "ジャズに合うクラシックカクテル" },
  { bar: Bar.find_by(name: "六本木ジャズクラブ"), category: "ウイスキー", is_main: false, description: "バーボンを中心としたアメリカンウイスキー" },

  { bar: Bar.find_by(name: "ミッドタウンワインセラー"), category: "ワイン", is_main: true, description: "世界最高峰のプレミアムワイン" },

  # 銀座エリア
  { bar: Bar.find_by(name: "Cocktail Laboratory"), category: "カクテル", is_main: true, description: "モダンテクニックを使った革新的カクテル" },

  { bar: Bar.find_by(name: "銀座クラシック"), category: "カクテル", is_main: true, description: "伝統的なクラシックカクテル" },
  { bar: Bar.find_by(name: "銀座クラシック"), category: "ブランデー", is_main: false, description: "コニャック、アルマニャック各種" },

  { bar: Bar.find_by(name: "ワインバー蔵人"), category: "ワイン", is_main: true, description: "国産ワインセレクション" },
  { bar: Bar.find_by(name: "ワインバー蔵人"), category: "日本酒", is_main: false, description: "ワインとのペアリング日本酒" },

  # 赤坂エリア
  { bar: Bar.find_by(name: "Piano Bar エレガンス"), category: "カクテル", is_main: true, description: "ピアノ演奏とともに楽しむクラシックカクテル" },
  { bar: Bar.find_by(name: "Piano Bar エレガンス"), category: "ウイスキー", is_main: false, description: "プレミアムウイスキー" },

  { bar: Bar.find_by(name: "赤坂サントリーバー"), category: "ウイスキー", is_main: true, description: "サントリーウイスキー全種類" },
  { bar: Bar.find_by(name: "赤坂サントリーバー"), category: "焼酎", is_main: false, description: "プレミアム焼酎" },

  # 浅草エリア
  { bar: Bar.find_by(name: "日本酒 蔵"), category: "日本酒", is_main: true, description: "全国47都道府県の地酒" },

  { bar: Bar.find_by(name: "浅草ほっぴん"), category: "焼酎", is_main: true, description: "九州を中心とした焼酎各種" },
  { bar: Bar.find_by(name: "浅草ほっぴん"), category: "日本酒", is_main: false, description: "庶民派日本酒" },

  # 品川エリア
  { bar: Bar.find_by(name: "Beer Garden TOKYO"), category: "ビール", is_main: true, description: "国内外のクラフトビール20種類" },

  { bar: Bar.find_by(name: "品川ステーションバー"), category: "ビール", is_main: true, description: "仕事帰りに飲みやすいビール各種" },
  { bar: Bar.find_by(name: "品川ステーションバー"), category: "ハイボール", is_main: false, description: "各種ハイボール・サワー" },

  # 神田エリア
  { bar: Bar.find_by(name: "和モダンバー 竹取"), category: "カクテル", is_main: true, description: "和素材を使った季節のオリジナルカクテル" },
  { bar: Bar.find_by(name: "和モダンバー 竹取"), category: "日本酒", is_main: false, description: "厳選された地酒" },

  { bar: Bar.find_by(name: "神田サラリーマン横丁"), category: "焼酎", is_main: true, description: "リーズナブルな焼酎各種" },
  { bar: Bar.find_by(name: "神田サラリーマン横丁"), category: "ビール", is_main: false, description: "生ビール・瓶ビール" },

  # 恵比寿エリア
  { bar: Bar.find_by(name: "恵比寿ワインセレクション"), category: "ワイン", is_main: true, description: "ソムリエ厳選ワイン" },

  { bar: Bar.find_by(name: "エビスビアホール"), category: "ビール", is_main: true, description: "エビスビール各種とドイツビール" },

  # 池袋エリア
  { bar: Bar.find_by(name: "池袋ナイトオウル"), category: "カクテル", is_main: true, description: "エンターテイメント性の高いカクテル" },
  { bar: Bar.find_by(name: "池袋ナイトオウル"), category: "ビール", is_main: false, description: "各種ビール・チューハイ" },

  { bar: Bar.find_by(name: "カクテルファクトリー池袋"), category: "カクテル", is_main: true, description: "SNS映えするオリジナルカクテル" },

  # 表参道エリア
  { bar: Bar.find_by(name: "表参道ヒルズバー"), category: "カクテル", is_main: true, description: "洗練されたオリジナルカクテル" },
  { bar: Bar.find_by(name: "表参道ヒルズバー"), category: "シャンパン", is_main: false, description: "プレミアムシャンパン" },

  # 下北沢エリア
  { bar: Bar.find_by(name: "下北クラフトサワー"), category: "サワー", is_main: true, description: "手作りサワー・クラフトチューハイ" },

  # 中野エリア
  { bar: Bar.find_by(name: "中野ブロードウェイバー"), category: "カクテル", is_main: true, description: "アニメキャラをモチーフにしたカクテル" },
  { bar: Bar.find_by(name: "中野ブロードウェイバー"), category: "日本酒", is_main: false, description: "アニメラベルの日本酒" },

  # 吉祥寺エリア
  { bar: Bar.find_by(name: "ハーモニカ横丁 音楽酒場"), category: "日本酒", is_main: true, description: "ジャズに合う地酒セレクション" },
  { bar: Bar.find_by(name: "ハーモニカ横丁 音楽酒場"), category: "焼酎", is_main: false, description: "音楽を聴きながら楽しむ焼酎" },

  # 上野エリア
  { bar: Bar.find_by(name: "上野アメ横酒場"), category: "焼酎", is_main: true, description: "庶民的な焼酎・日本酒" },
  { bar: Bar.find_by(name: "上野アメ横酒場"), category: "ビール", is_main: false, description: "立ち飲みスタイルのビール" },

  # 秋葉原エリア
  { bar: Bar.find_by(name: "電気街カクテルバー"), category: "カクテル", is_main: true, description: "電子機器をモチーフにしたユニークカクテル" },

  # 築地エリア
  { bar: Bar.find_by(name: "築地市場酒場"), category: "日本酒", is_main: true, description: "新鮮な魚介に合う日本酒" },
  { bar: Bar.find_by(name: "築地市場酒場"), category: "焼酎", is_main: false, description: "海鮮に合う焼酎" },

  # 有楽町エリア
  { bar: Bar.find_by(name: "有楽町ガード下酒場"), category: "焼酎", is_main: true, description: "昭和の雰囲気を味わう焼酎" },
  { bar: Bar.find_by(name: "有楽町ガード下酒場"), category: "日本酒", is_main: false, description: "懐かしい銘柄の日本酒" },

  # 高級バー
  { bar: Bar.find_by(name: "プレミアムラウンジ麻布"), category: "ブランデー", is_main: true, description: "世界最高峰のコニャック・アルマニャック" },
  { bar: Bar.find_by(name: "プレミアムラウンジ麻布"), category: "ウイスキー", is_main: false, description: "希少なプレミアムウイスキー" },

  { bar: Bar.find_by(name: "ザ・リッツバー"), category: "カクテル", is_main: true, description: "芸術的なシグネチャーカクテル" },
  { bar: Bar.find_by(name: "ザ・リッツバー"), category: "シャンパン", is_main: false, description: "世界三大シャンパンメゾン" }
]

puts "スペシャリティデータを作成中..."

specialties_data.each_with_index do |specialty_data, index|
  if specialty_data[:bar]
    specialty = Specialty.create!(specialty_data)
    puts "[#{index + 1}/#{specialties_data.length}] 作成完了: #{specialty.bar.name} - #{specialty.category}"
  else
    puts "⚠️  バーが見つかりません: #{specialty_data}"
  end
end

puts ""
puts "🎉 充実したサンプルデータの作成が完了しました！"
puts "=" * 50
puts "📊 作成データ統計"
puts "=" * 50
puts "🏮 Bar: #{Bar.count}件"
puts "⭐ Specialty: #{Specialty.count}件"
puts ""

# エリア別統計
puts "📍 エリア別統計:"
areas = ["渋谷", "新宿", "六本木", "銀座", "赤坂", "浅草", "品川", "神田", "恵比寿", "池袋", "表参道", "下北沢", "中野", "吉祥寺", "上野", "秋葉原", "築地", "有楽町", "麻布"]
areas.each do |area|
  count = Bar.where("address LIKE ?", "%#{area}%").count
  puts "  #{area}: #{count}件" if count > 0
end

# 価格帯別統計
puts ""
puts "💰 価格帯別統計:"
price_ranges = Bar.group(:price_range).count.sort_by { |range, count| range.scan(/\d+/).first.to_i }
price_ranges.each do |range, count|
  puts "  #{range}: #{count}件"
end

# 喫煙状況別統計
puts ""
puts "🚭 喫煙状況別統計:"
Bar.group(:smoking_status).count.each do |status, count|
  puts "  #{status}: #{count}件"
end

# スペシャリティ別統計
puts ""
puts "🍸 スペシャリティ別統計:"
Specialty.group(:category).count.sort_by { |cat, count| -count }.each do |category, count|
  puts "  #{category}: #{count}件"
end
