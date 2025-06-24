unless Rails.env.production?
  Bar.destroy_all
  Specialty.destroy_all
end

bars_data = [
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
    name: "和モダンバー 竹取",
    address: "東京都千代田区神田2-5-1",
    price_range: "¥3,500-5,500",
    smoking_status: "分煙",
    description: "日本の伝統とモダンが融合した和風バー。季節の食材を使ったオリジナルカクテルと和の趣が楽しめます。",
    phone: "03-0123-4567",
    business_hours: "18:00-01:30",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  }
]

puts "画像付きバーのサンプルデータを作成中..."

bars_data.each do |bar_data|
  bar = Bar.create!(bar_data)
  puts "作成完了: #{bar.name}"
end

specialties_data = [
  { bar: Bar.find_by(name: "Bar High Five"), category: "カクテル", is_main: true, description: "クラシックカクテルからオリジナルまで" },
  { bar: Bar.find_by(name: "Bar High Five"), category: "ウイスキー", is_main: false, description: "スコッチ、バーボンを中心に" },

  { bar: Bar.find_by(name: "Whiskey Library"), category: "ウイスキー", is_main: true, description: "世界中のウイスキー300種類以上" },
  { bar: Bar.find_by(name: "Whiskey Library"), category: "カクテル", is_main: false, description: "ウイスキーベースカクテル" },

  { bar: Bar.find_by(name: "Wine & Dine SAKURA"), category: "ワイン", is_main: true, description: "フランス、イタリア産を中心とした厳選ワイン" },
  { bar: Bar.find_by(name: "Wine & Dine SAKURA"), category: "カクテル", is_main: false, description: "ワインベースカクテル" },

  { bar: Bar.find_by(name: "日本酒 蔵"), category: "日本酒", is_main: true, description: "全国47都道府県の地酒" },

  { bar: Bar.find_by(name: "Cocktail Laboratory"), category: "カクテル", is_main: true, description: "モダンテクニックを使った革新的カクテル" },

  { bar: Bar.find_by(name: "Beer Garden TOKYO"), category: "ビール", is_main: true, description: "国内外のクラフトビール20種類" },

  { bar: Bar.find_by(name: "Piano Bar エレガンス"), category: "カクテル", is_main: true, description: "ピアノ演奏とともに楽しむクラシックカクテル" },
  { bar: Bar.find_by(name: "Piano Bar エレガンス"), category: "ウイスキー", is_main: false, description: "プレミアムウイスキー" },

  { bar: Bar.find_by(name: "隠れ家バー 月光"), category: "日本酒", is_main: true, description: "厳選された日本酒" },
  { bar: Bar.find_by(name: "隠れ家バー 月光"), category: "カクテル", is_main: false, description: "和のテイストを活かしたオリジナルカクテル" },

  { bar: Bar.find_by(name: "Rooftop Lounge SKY"), category: "カクテル", is_main: true, description: "夜景とともに楽しむシャンパンカクテル" },
  { bar: Bar.find_by(name: "Rooftop Lounge SKY"), category: "ワイン", is_main: false, description: "スパークリングワイン各種" },

  { bar: Bar.find_by(name: "和モダンバー 竹取"), category: "カクテル", is_main: true, description: "和素材を使った季節のオリジナルカクテル" },
  { bar: Bar.find_by(name: "和モダンバー 竹取"), category: "日本酒", is_main: false, description: "厳選された地酒" }
]

puts "スペシャリティデータを作成中..."

specialties_data.each do |specialty_data|
  if specialty_data[:bar]
    specialty = Specialty.create!(specialty_data)
    puts "作成完了: #{specialty.bar.name} - #{specialty.category}"
  end
end

puts "画像付きサンプルデータの作成が完了しました！"
puts "Bar: #{Bar.count}件"
puts "Specialty: #{Specialty.count}件"
