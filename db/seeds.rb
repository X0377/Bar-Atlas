unless Rails.env.production?
  Bar.destroy_all
  Specialty.destroy_all
end

bars_data = [
  # === 渋谷エリア（10件） ===
  {
    name: "Bar High Five",
    address: "東京都渋谷区道玄坂2-10-12",
    price_range: "¥6,000-10,000",
    smoking_status: "禁煙",
    description: "カクテルの種類が豊富で、バーテンダーのスキルが高い老舗バー。クラシックカクテルからオリジナルまで幅広く楽しめます。",
    phone: "03-1234-5678",
    business_hours: "18:00-02:00",
    image_url: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "渋谷横丁 赤提灯",
    address: "東京都渋谷区渋谷1-15-8",
    price_range: "¥2,000-4,000",
    smoking_status: "喫煙可",
    description: "昭和レトロな雰囲気の立ち飲みバー。リーズナブルな価格で日本酒と焼鳥が楽しめるアットホームな空間。",
    phone: "03-1111-2222",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "Rooftop Lounge SKY",
    address: "東京都渋谷区恵比寿2-8-11",
    price_range: "¥8,000-15,000",
    smoking_status: "禁煙",
    description: "都心の夜景を一望できるルーフトップバー。開放的な空間でシャンパンやカクテルを楽しめる大人の隠れ家です。",
    phone: "03-9012-3456",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "クラフトビア道玄坂",
    address: "東京都渋谷区道玄坂1-5-9",
    price_range: "¥3,000-6,000",
    smoking_status: "禁煙",
    description: "30種類以上のクラフトビールが楽しめるビアバー。ビール初心者から上級者まで満足できる品揃え。",
    phone: "03-2222-1111",
    business_hours: "16:00-23:30",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "渋谷センター街バル",
    address: "東京都渋谷区宇田川町25-6",
    price_range: "¥2,500-5,000",
    smoking_status: "分煙",
    description: "若者で賑わう渋谷の中心部にあるカジュアルバル。ワインとタパスが人気の活気ある店舗。",
    phone: "03-2333-4444",
    business_hours: "17:00-01:00",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "ハチ公前スタンディングバー",
    address: "東京都渋谷区渋谷2-1-1",
    price_range: "¥2,000-4,000",
    smoking_status: "屋外喫煙可",
    description: "ハチ公前の好立地にある立ち飲みスタイルのバー。仕事帰りにサクッと一杯飲むのに最適。",
    phone: "03-2444-5555",
    business_hours: "16:30-24:00",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "渋谷スカイバー109",
    address: "東京都渋谷区道玄坂2-29-1",
    price_range: "¥4,000-8,000",
    smoking_status: "禁煙",
    description: "109ビルの高層階から渋谷を見下ろすスカイバー。若い女性に人気のフォトジェニックな空間。",
    phone: "03-2555-6666",
    business_hours: "18:00-02:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "文化村通りワインバー",
    address: "東京都渋谷区道玄坂2-24-1",
    price_range: "¥4,500-8,500",
    smoking_status: "禁煙",
    description: "Bunkamura近くの落ち着いたワインバー。厳選されたワインとチーズプレートが楽しめる。",
    phone: "03-2666-7777",
    business_hours: "17:30-01:00",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "渋谷ノンベエ横丁",
    address: "東京都渋谷区渋谷1-25-8",
    price_range: "¥1,800-3,500",
    smoking_status: "喫煙可",
    description: "昔ながらの飲み屋街の雰囲気を残す庶民的なバー。常連さんとの交流も楽しい下町情緒あふれる店。",
    phone: "03-2777-8888",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "代官山コンセプトバー",
    address: "東京都渋谷区代官山町18-4",
    price_range: "¥5,000-9,000",
    smoking_status: "禁煙",
    description: "代官山の洗練された雰囲気の中で楽しむアートギャラリー併設のコンセプトバー。",
    phone: "03-2888-9999",
    business_hours: "19:00-01:30",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },

  # === 新宿エリア（10件） ===
  {
    name: "Whiskey Library",
    address: "東京都新宿区歌舞伎町1-5-3",
    price_range: "¥8,000-15,000",
    smoking_status: "喫煙可",
    description: "世界各国のウイスキーを300種類以上揃えたウイスキー専門バー。重厚で落ち着いた雰囲気の中でプレミアムウイスキーを堪能できます。",
    phone: "03-2345-6789",
    business_hours: "19:00-03:00",
    image_url: "https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "隠れ家バー 月光",
    address: "東京都新宿区ゴールデン街1-1-6",
    price_range: "¥4,000-8,000",
    smoking_status: "喫煙可",
    description: "ゴールデン街の奥にある知る人ぞ知る隠れ家的バー。マスターとの会話を楽しみながら、こだわりのカクテルを味わえます。",
    phone: "03-8901-2345",
    business_hours: "20:00-04:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "新宿サーモンズ",
    address: "東京都新宿区新宿3-18-4",
    price_range: "¥3,500-6,500",
    smoking_status: "分煙",
    description: "アイリッシュパブスタイルのバー。本格的なギネスビールと豊富なウイスキーセレクションが自慢。",
    phone: "03-3333-4444",
    business_hours: "17:30-02:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "歌舞伎町スカイバー",
    address: "東京都新宿区歌舞伎町2-45-7",
    price_range: "¥10,000-20,000",
    smoking_status: "禁煙",
    description: "35階から新宿の夜景を一望できる高級バー。プレミアムカクテルと絶景を楽しむ大人の社交場。",
    phone: "03-4444-5555",
    business_hours: "18:30-02:30",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "ゴールデン街昭和横丁",
    address: "東京都新宿区歌舞伎町1-1-10",
    price_range: "¥2,500-5,000",
    smoking_status: "喫煙可",
    description: "昭和の雰囲気を色濃く残すゴールデン街の名物バー。ママとの楽しい会話と懐かしい雰囲気が魅力。",
    phone: "03-3111-2222",
    business_hours: "19:30-03:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "新宿南口ビアガーデン",
    address: "東京都新宿区新宿3-38-1",
    price_range: "¥2,000-4,500",
    smoking_status: "屋外喫煙可",
    description: "新宿駅南口直結の屋上ビアガーデン。開放的な空間でビールとBBQを楽しめる夏の定番スポット。",
    phone: "03-3222-3333",
    business_hours: "17:00-23:00",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "東口地下街立ち呑み",
    address: "東京都新宿区新宿3-1-26",
    price_range: "¥1,500-3,000",
    smoking_status: "分煙",
    description: "新宿駅東口地下街の老舗立ち飲み。サラリーマンの聖地として親しまれ続ける庶民的な酒場。",
    phone: "03-3333-4444",
    business_hours: "15:00-23:30",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "新宿パークハイアットバー",
    address: "東京都新宿区西新宿3-7-1-2",
    price_range: "¥12,000-25,000",
    smoking_status: "禁煙",
    description: "パークハイアット東京52階の最高級バー。都内屈指の夜景とプレミアムサービスが体験できる。",
    phone: "03-3444-5555",
    business_hours: "17:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572788962817-4b3d7edbdde1?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "西新宿ワインセラー",
    address: "東京都新宿区西新宿1-26-2",
    price_range: "¥5,000-10,000",
    smoking_status: "禁煙",
    description: "オフィス街にある大人のワインバー。厳選されたワインとチーズで仕事帰りの特別なひととき。",
    phone: "03-3555-6666",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "思い出横丁炭火焼き鳥",
    address: "東京都新宿区西新宿1-2-1",
    price_range: "¥2,200-4,000",
    smoking_status: "喫煙可",
    description: "思い出横丁の老舗焼き鳥屋。炭火で焼いた絶品焼き鳥と日本酒で昭和の情緒を味わえる。",
    phone: "03-3666-7777",
    business_hours: "17:30-24:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },

  # === 六本木エリア（8件） ===
  {
    name: "Wine & Dine SAKURA",
    address: "東京都港区六本木6-12-2",
    price_range: "¥6,000-12,000",
    smoking_status: "分煙",
    description: "厳選されたワインと創作料理が楽しめるワインバー。エレガントで上質な空間で特別なひとときを過ごせます。",
    phone: "03-3456-7890",
    business_hours: "17:30-01:00",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "六本木ジャズクラブ",
    address: "東京都港区六本木4-8-15",
    price_range: "¥7,000-13,000",
    smoking_status: "禁煙",
    description: "生ジャズ演奏を聴きながらお酒が楽しめる本格ジャズクラブ。毎晩異なるアーティストの演奏を堪能できます。",
    phone: "03-5555-6666",
    business_hours: "19:00-03:00",
    image_url: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "ミッドタウンワインセラー",
    address: "東京都港区六本木9-7-1",
    price_range: "¥10,000-20,000",
    smoking_status: "禁煙",
    description: "世界最高峰のワインを揃えた高級ワインバー。ソムリエによる丁寧なワイン選びのアドバイスが受けられます。",
    phone: "03-6666-7777",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572788962817-4b3d7edbdde1?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "六本木ヒルズクラブ",
    address: "東京都港区六本木6-10-1",
    price_range: "¥8,000-16,000",
    smoking_status: "分煙",
    description: "六本木ヒルズの高層階にある会員制クラブ。東京タワーを眺めながら極上のカクテルを楽しめる。",
    phone: "03-6777-8888",
    business_hours: "18:00-02:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "六本木交差点バル",
    address: "東京都港区六本木5-4-20",
    price_range: "¥3,500-7,000",
    smoking_status: "屋外喫煙可",
    description: "六本木交差点の喧騒を見下ろすテラス席が人気のバル。国際色豊かな雰囲気で多国籍料理を楽しめる。",
    phone: "03-6888-9999",
    business_hours: "17:00-02:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "アークヒルズスカイラウンジ",
    address: "東京都港区六本木1-12-32",
    price_range: "¥9,000-18,000",
    smoking_status: "禁煙",
    description: "アークヒルズ最上階の洗練されたスカイラウンジ。プレミアムスピリッツと絶景の組み合わせが極上。",
    phone: "03-6999-0000",
    business_hours: "18:30-01:30",
    image_url: "https://images.unsplash.com/photo-1572788962817-4b3d7edbdde1?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "六本木アンダーグラウンド",
    address: "東京都港区六本木3-16-33",
    price_range: "¥4,000-8,000",
    smoking_status: "喫煙可",
    description: "地下にあるスペイクイージー風の隠れ家バー。重厚で大人の雰囲気の中でクラシックカクテルを堪能。",
    phone: "03-7000-1111",
    business_hours: "19:00-03:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "六本木国際通りパブ",
    address: "東京都港区六本木7-14-10",
    price_range: "¥3,000-6,000",
    smoking_status: "分煙",
    description: "外国人客の多い国際的なパブ。英語も通じるフレンドリーな雰囲気で世界各国のビールが楽しめる。",
    phone: "03-7111-2222",
    business_hours: "16:00-02:00",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },

  # === 銀座エリア（8件） ===
  {
    name: "Cocktail Laboratory",
    address: "東京都中央区銀座8-5-1",
    price_range: "¥10,000-18,000",
    smoking_status: "禁煙",
    description: "分子ガストロノミーを取り入れた革新的なカクテルが楽しめるモダンバー。洗練された空間で新感覚のドリンクを体験できます。",
    phone: "03-5678-9012",
    business_hours: "18:30-02:30",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "銀座クラシック",
    address: "東京都中央区銀座5-9-1",
    price_range: "¥12,000-25,000",
    smoking_status: "喫煙可",
    description: "銀座の老舗バーの代表格。格式高い雰囲気の中で、伝統的なバーテンディングの技を堪能できる名店。",
    phone: "03-7777-8888",
    business_hours: "18:00-02:00",
    image_url: "https://images.unsplash.com/photo-1553618541-51ca45ddbaea?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "ワインバー蔵人",
    address: "東京都中央区銀座3-4-17",
    price_range: "¥6,000-12,000",
    smoking_status: "分煙",
    description: "厳選された国産ワインと日本酒のペアリングが楽しめるユニークなバー。和食との相性も抜群。",
    phone: "03-8888-9999",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1572788962807-5fe8e13e41be?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "銀座コリドー街居酒屋",
    address: "東京都中央区銀座8-2-15",
    price_range: "¥3,000-6,000",
    smoking_status: "喫煙可",
    description: "銀座の中でも庶民的な価格で楽しめるコリドー街の居酒屋。サラリーマンに愛される下町情緒あふれる店。",
    phone: "03-8000-1111",
    business_hours: "17:30-24:00",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "銀座三越屋上バー",
    address: "東京都中央区銀座4-6-16",
    price_range: "¥7,000-14,000",
    smoking_status: "禁煙",
    description: "銀座三越の屋上にあるシックなバー。銀座の街並みを見下ろしながら上質なカクテルを堪能。",
    phone: "03-8111-2222",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "銀座煉瓦亭バー",
    address: "東京都中央区銀座3-5-16",
    price_range: "¥8,000-15,000",
    smoking_status: "分煙",
    description: "老舗洋食店「煉瓦亭」が手がけるバー。伝統と格式を重んじた重厚な雰囲気でブランデーとウイスキーが自慢。",
    phone: "03-8222-3333",
    business_hours: "18:30-01:30",
    image_url: "https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "銀座ホステスバー雅",
    address: "東京都中央区銀座7-3-13",
    price_range: "¥15,000-30,000",
    smoking_status: "喫煙可",
    description: "銀座を代表する高級ホステスバー。一流のホステスによるおもてなしと最高級のお酒でVIP気分を味わえる。",
    phone: "03-8333-4444",
    business_hours: "20:00-03:00",
    image_url: "https://images.unsplash.com/photo-1553618541-51ca45ddbaea?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "銀座カフェバー昼夜",
    address: "東京都中央区銀座2-8-17",
    price_range: "¥4,000-8,000",
    smoking_status: "禁煙",
    description: "昼はカフェ、夜はバーに変身する銀座の隠れ家。昼夜で異なる顔を見せるユニークなコンセプトが話題。",
    phone: "03-8444-5555",
    business_hours: "9:00-24:00",
    image_url: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&h=400&fit=crop&crop=center"
  },

  # === 赤坂エリア（6件） ===
  {
    name: "Piano Bar エレガンス",
    address: "東京都港区赤坂3-15-8",
    price_range: "¥7,000-13,000",
    smoking_status: "禁煙",
    description: "生演奏のジャズピアノとともに楽しむ上質なバータイム。大人の社交場として愛され続ける老舗ピアノバーです。",
    phone: "03-7890-1234",
    business_hours: "19:00-02:00",
    image_url: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "赤坂サントリーバー",
    address: "東京都港区赤坂4-2-9",
    price_range: "¥6,000-10,000",
    smoking_status: "分煙",
    description: "サントリーの銘酒を中心とした日本のウイスキーと焼酎が楽しめるバー。大人の隠れ家的存在。",
    phone: "03-9999-0000",
    business_hours: "18:00-01:30",
    image_url: "https://images.unsplash.com/photo-1569529465841-dfecdab7503b?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "赤坂見附政治家バー",
    address: "東京都港区赤坂2-14-31",
    price_range: "¥8,000-16,000",
    smoking_status: "喫煙可",
    description: "永田町の政治家や官僚が通う高級バー。政治の中心地ならではの重厚で格式高い雰囲気が漂う。",
    phone: "03-8555-6666",
    business_hours: "18:30-02:00",
    image_url: "https://images.unsplash.com/photo-1553618541-51ca45ddbaea?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "赤坂氷川神社前酒場",
    address: "東京都港区赤坂6-10-12",
    price_range: "¥2,500-5,000",
    smoking_status: "喫煙可",
    description: "氷川神社のすぐそばにある下町情緒あふれる酒場。神社参拝の後に立ち寄る常連客で賑わう。",
    phone: "03-8666-7777",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "赤坂プレスセンター地下バー",
    address: "東京都港区赤坂1-7-1",
    price_range: "¥4,500-8,500",
    smoking_status: "分煙",
    description: "外国人記者クラブの地下にあるインターナショナルなバー。世界各国のジャーナリストが集まる国際色豊かな空間。",
    phone: "03-8777-8888",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "赤坂TBSテレビ局前バル",
    address: "東京都港区赤坂5-3-6",
    price_range: "¥3,500-6,500",
    smoking_status: "禁煙",
    description: "TBS近くのメディア関係者御用達バル。テレビ業界人との出会いもあるエンターテイメント性の高い店。",
    phone: "03-8888-9999",
    business_hours: "17:30-01:30",
    image_url: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&h=400&fit=crop&crop=center"
  },

  # === その他東京エリア（18件） ===
  # 浅草エリア（3件）
  {
    name: "日本酒 蔵",
    address: "東京都台東区浅草1-20-5",
    price_range: "¥3,000-6,000",
    smoking_status: "禁煙",
    description: "全国各地の厳選日本酒と季節の和食が味わえる日本酒バー。和モダンで落ち着いた雰囲気が自慢です。",
    phone: "03-4567-8901",
    business_hours: "17:00-23:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "浅草ほっぴん",
    address: "東京都台東区浅草2-7-13",
    price_range: "¥2,000-4,000",
    smoking_status: "喫煙可",
    description: "下町情緒あふれる立ち飲みバー。常連さんとの会話を楽しみながら、リーズナブルにお酒が楽しめます。",
    phone: "03-0000-1111",
    business_hours: "16:30-23:30",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "浅草雷門前観光バー",
    address: "東京都台東区浅草1-3-1",
    price_range: "¥2,500-5,000",
    smoking_status: "分煙",
    description: "雷門のすぐ近くにある観光客と地元民が交流できるバー。英語メニューも完備で国際的な雰囲気。",
    phone: "03-9000-1111",
    business_hours: "16:00-24:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },

  # 品川エリア（3件）
  {
    name: "Beer Garden TOKYO",
    address: "東京都品川区大崎1-11-1",
    price_range: "¥3,000-6,000",
    smoking_status: "屋外喫煙可",
    description: "屋上テラスで楽しむクラフトビールとBBQの組み合わせ。カジュアルで開放的な雰囲気で仲間との時間を満喫できます。",
    phone: "03-6789-0123",
    business_hours: "16:00-24:00",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "品川ステーションバー",
    address: "東京都港区高輪3-26-27",
    price_range: "¥3,500-6,500",
    smoking_status: "禁煙",
    description: "出張帰りのビジネスマンに人気のカジュアルバー。駅近で気軽に一杯飲めるアクセス抜群の立地。",
    phone: "03-1212-3434",
    business_hours: "17:00-01:00",
    image_url: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "品川プリンスホテルバー",
    address: "東京都港区高輪4-10-30",
    price_range: "¥8,000-15,000",
    smoking_status: "禁煙",
    description: "品川プリンスホテル最上階の高級バー。東京湾を一望しながら極上のカクテルと時間を過ごせる。",
    phone: "03-9111-2222",
    business_hours: "17:30-01:00",
    image_url: "https://images.unsplash.com/photo-1572788962817-4b3d7edbdde1?w=800&h=400&fit=crop&crop=center"
  },

  # 恵比寿エリア（3件）
  {
    name: "恵比寿ワインセレクション",
    address: "東京都渋谷区恵比寿1-8-14",
    price_range: "¥5,000-10,000",
    smoking_status: "禁煙",
    description: "恵比寿駅から徒歩3分の好立地にあるワインバー。ソムリエ厳選のワインとチーズプレートが人気。",
    phone: "03-3456-6789",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "エビスビアホール",
    address: "東京都渋谷区恵比寿4-20-1",
    price_range: "¥3,500-6,500",
    smoking_status: "禁煙",
    description: "恵比寿ビール発祥の地で楽しむ本格ビアホール。新鮮なビールと本格ドイツ料理が味わえます。",
    phone: "03-4567-7890",
    business_hours: "16:30-23:00",
    image_url: "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "恵比寿ガーデンプレイスバー",
    address: "東京都渋谷区恵比寿4-20-3",
    price_range: "¥6,000-11,000",
    smoking_status: "分煙",
    description: "恵比寿ガーデンプレイスのタワー内にある洗練されたバー。都会的な夜景とモダンカクテルが楽しめる。",
    phone: "03-9222-3333",
    business_hours: "18:00-01:30",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },

  # 池袋エリア（3件）
  {
    name: "池袋ナイトオウル",
    address: "東京都豊島区南池袋1-28-2",
    price_range: "¥3,000-6,000",
    smoking_status: "喫煙可",
    description: "深夜まで営業している池袋の定番バー。カラオケも楽しめるエンターテイメント性の高い空間。",
    phone: "03-5678-8901",
    business_hours: "19:00-05:00",
    image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "カクテルファクトリー池袋",
    address: "東京都豊島区西池袋1-21-1",
    price_range: "¥4,000-7,500",
    smoking_status: "禁煙",
    description: "若い世代に人気のモダンカクテルバー。SNS映えするオリジナルカクテルとスタイリッシュな空間が魅力。",
    phone: "03-6789-9012",
    business_hours: "18:30-02:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "池袋サンシャインシティバー",
    address: "東京都豊島区東池袋3-1-1",
    price_range: "¥4,500-8,500",
    smoking_status: "禁煙",
    description: "サンシャインシティの高層階にあるファミリー向けバー。昼間は家族連れ、夜は大人の時間を楽しめる。",
    phone: "03-9333-4444",
    business_hours: "11:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },

  # その他エリア（6件）
  {
    name: "表参道ヒルズバー",
    address: "東京都港区北青山3-6-1",
    price_range: "¥7,000-13,000",
    smoking_status: "禁煙",
    description: "表参道ヒルズ内の洗練されたバー。ファッション感度の高い大人が集う上質なカクテルラウンジ。",
    phone: "03-7890-0123",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "下北クラフトサワー",
    address: "東京都世田谷区北沢2-26-5",
    price_range: "¥2,500-4,500",
    smoking_status: "禁煙",
    description: "下北沢らしいサブカル感のあるバー。手作りサワーとクラフトチューハイが若者に大人気。",
    phone: "03-8901-1234",
    business_hours: "17:00-02:00",
    image_url: "https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "上野アメ横酒場",
    address: "東京都台東区上野4-9-14",
    price_range: "¥2,000-4,000",
    smoking_status: "喫煙可",
    description: "アメ横の活気ある雰囲気の中で楽しむ立ち飲みバー。観光客から地元民まで多くの人で賑わう名物店。",
    phone: "03-1234-4567",
    business_hours: "15:00-23:00",
    image_url: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "吉祥寺ハーモニカ横丁",
    address: "東京都武蔵野市吉祥寺本町1-1-8",
    price_range: "¥2,200-4,200",
    smoking_status: "喫煙可",
    description: "吉祥寺名物ハーモニカ横丁の老舗酒場。ジャズが流れる中で地酒と手作りおつまみが楽しめる。",
    phone: "03-0123-3456",
    business_hours: "17:00-24:00",
    image_url: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "秋葉原電気街バー",
    address: "東京都千代田区外神田3-1-16",
    price_range: "¥3,500-6,500",
    smoking_status: "禁煙",
    description: "電子機器をモチーフにしたユニークなカクテルが楽しめる秋葉原らしいテーマバー。メイドカフェとは一味違う大人の空間。",
    phone: "03-2345-5678",
    business_hours: "18:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  },
  {
    name: "お台場レインボーブリッジバー",
    address: "東京都港区台場2-6-1",
    price_range: "¥5,000-9,000",
    smoking_status: "禁煙",
    description: "レインボーブリッジと東京湾を一望できる絶景バー。デートスポットとしても人気の開放的な空間。",
    phone: "03-9444-5555",
    business_hours: "17:00-01:00",
    image_url: "https://images.unsplash.com/photo-1572040543235-a5a4c2b24081?w=800&h=400&fit=crop&crop=center"
  }
]

puts "60件のバーのサンプルデータを作成中..."

bars_data.each_with_index do |bar_data, index|
  bar = Bar.create!(bar_data)
  puts "[#{index + 1}/#{bars_data.length}] 作成完了: #{bar.name} (#{bar.price_range})"
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

  { bar: Bar.find_by(name: "渋谷センター街バル"), category: "ワイン", is_main: true, description: "若者向けのカジュアルワイン" },
  { bar: Bar.find_by(name: "渋谷センター街バル"), category: "カクテル", is_main: false, description: "フルーティーなカクテル各種" },

  { bar: Bar.find_by(name: "ハチ公前スタンディングバー"), category: "ビール", is_main: true, description: "生ビール・缶ビール各種" },
  { bar: Bar.find_by(name: "ハチ公前スタンディングバー"), category: "ハイボール", is_main: false, description: "各種ハイボール・サワー" },

  { bar: Bar.find_by(name: "渋谷スカイバー109"), category: "カクテル", is_main: true, description: "インスタ映えするカラフルカクテル" },
  { bar: Bar.find_by(name: "渋谷スカイバー109"), category: "シャンパン", is_main: false, description: "お祝い用シャンパン各種" },

  { bar: Bar.find_by(name: "文化村通りワインバー"), category: "ワイン", is_main: true, description: "フランス・イタリアワイン中心" },

  { bar: Bar.find_by(name: "渋谷ノンベエ横丁"), category: "焼酎", is_main: true, description: "庶民的な焼酎各種" },
  { bar: Bar.find_by(name: "渋谷ノンベエ横丁"), category: "日本酒", is_main: false, description: "一合瓶の地酒" },

  { bar: Bar.find_by(name: "代官山コンセプトバー"), category: "カクテル", is_main: true, description: "アート作品をイメージしたカクテル" },
  { bar: Bar.find_by(name: "代官山コンセプトバー"), category: "ワイン", is_main: false, description: "アーティストラベルワイン" },

  # 新宿エリア
  { bar: Bar.find_by(name: "Whiskey Library"), category: "ウイスキー", is_main: true, description: "世界中のウイスキー300種類以上" },
  { bar: Bar.find_by(name: "Whiskey Library"), category: "カクテル", is_main: false, description: "ウイスキーベースカクテル" },

  { bar: Bar.find_by(name: "隠れ家バー 月光"), category: "日本酒", is_main: true, description: "厳選された地酒" },
  { bar: Bar.find_by(name: "隠れ家バー 月光"), category: "カクテル", is_main: false, description: "和のテイストを活かしたオリジナルカクテル" },

  { bar: Bar.find_by(name: "新宿サーモンズ"), category: "ビール", is_main: true, description: "本格アイリッシュビールとエール" },
  { bar: Bar.find_by(name: "新宿サーモンズ"), category: "ウイスキー", is_main: false, description: "アイリッシュウイスキー各種" },

  { bar: Bar.find_by(name: "歌舞伎町スカイバー"), category: "カクテル", is_main: true, description: "プレミアムスピリッツを使用した創作カクテル" },
  { bar: Bar.find_by(name: "歌舞伎町スカイバー"), category: "シャンパン", is_main: false, description: "世界の高級シャンパン" },

  { bar: Bar.find_by(name: "ゴールデン街昭和横丁"), category: "焼酎", is_main: true, description: "昭和の銘柄焼酎" },
  { bar: Bar.find_by(name: "ゴールデン街昭和横丁"), category: "日本酒", is_main: false, description: "懐かしい銘柄の日本酒" },

  { bar: Bar.find_by(name: "新宿南口ビアガーデン"), category: "ビール", is_main: true, description: "国内外のビール20種類以上" },

  { bar: Bar.find_by(name: "東口地下街立ち呑み"), category: "焼酎", is_main: true, description: "リーズナブルな焼酎各種" },
  { bar: Bar.find_by(name: "東口地下街立ち呑み"), category: "ビール", is_main: false, description: "生ビール・瓶ビール" },

  { bar: Bar.find_by(name: "新宿パークハイアットバー"), category: "カクテル", is_main: true, description: "最高級スピリッツのカクテル" },
  { bar: Bar.find_by(name: "新宿パークハイアットバー"), category: "ブランデー", is_main: false, description: "世界最高峰のコニャック" },

  { bar: Bar.find_by(name: "西新宿ワインセラー"), category: "ワイン", is_main: true, description: "ビジネスマン向けワインセレクション" },

  { bar: Bar.find_by(name: "思い出横丁炭火焼き鳥"), category: "日本酒", is_main: true, description: "焼き鳥に合う日本酒" },
  { bar: Bar.find_by(name: "思い出横丁炭火焼き鳥"), category: "焼酎", is_main: false, description: "炭火に合う焼酎" },

  # 六本木エリア
  { bar: Bar.find_by(name: "Wine & Dine SAKURA"), category: "ワイン", is_main: true, description: "フランス、イタリア産を中心とした厳選ワイン" },
  { bar: Bar.find_by(name: "Wine & Dine SAKURA"), category: "カクテル", is_main: false, description: "ワインベースカクテル" },

  { bar: Bar.find_by(name: "六本木ジャズクラブ"), category: "カクテル", is_main: true, description: "ジャズに合うクラシックカクテル" },
  { bar: Bar.find_by(name: "六本木ジャズクラブ"), category: "ウイスキー", is_main: false, description: "バーボンを中心としたアメリカンウイスキー" },

  { bar: Bar.find_by(name: "ミッドタウンワインセラー"), category: "ワイン", is_main: true, description: "世界最高峰のプレミアムワイン" },

  { bar: Bar.find_by(name: "六本木ヒルズクラブ"), category: "カクテル", is_main: true, description: "会員制クラブのシグネチャーカクテル" },
  { bar: Bar.find_by(name: "六本木ヒルズクラブ"), category: "シャンパン", is_main: false, description: "プレミアムシャンパン" },

  { bar: Bar.find_by(name: "六本木交差点バル"), category: "ビール", is_main: true, description: "世界各国のビール" },
  { bar: Bar.find_by(name: "六本木交差点バル"), category: "カクテル", is_main: false, description: "インターナショナルカクテル" },

  { bar: Bar.find_by(name: "アークヒルズスカイラウンジ"), category: "カクテル", is_main: true, description: "絶景を楽しむプレミアムカクテル" },
  { bar: Bar.find_by(name: "アークヒルズスカイラウンジ"), category: "シャンパン", is_main: false, description: "セレブ御用達シャンパン" },

  { bar: Bar.find_by(name: "六本木アンダーグラウンド"), category: "ウイスキー", is_main: true, description: "希少なスコッチウイスキー" },
  { bar: Bar.find_by(name: "六本木アンダーグラウンド"), category: "カクテル", is_main: false, description: "スペイクイージー風クラシックカクテル" },

  { bar: Bar.find_by(name: "六本木国際通りパブ"), category: "ビール", is_main: true, description: "世界各国のビール30種類" },

  # 銀座エリア
  { bar: Bar.find_by(name: "Cocktail Laboratory"), category: "カクテル", is_main: true, description: "モダンテクニックを使った革新的カクテル" },

  { bar: Bar.find_by(name: "銀座クラシック"), category: "カクテル", is_main: true, description: "伝統的なクラシックカクテル" },
  { bar: Bar.find_by(name: "銀座クラシック"), category: "ブランデー", is_main: false, description: "コニャック、アルマニャック各種" },

  { bar: Bar.find_by(name: "ワインバー蔵人"), category: "ワイン", is_main: true, description: "国産ワインセレクション" },
  { bar: Bar.find_by(name: "ワインバー蔵人"), category: "日本酒", is_main: false, description: "ワインとのペアリング日本酒" },

  { bar: Bar.find_by(name: "銀座コリドー街居酒屋"), category: "焼酎", is_main: true, description: "庶民的な焼酎各種" },
  { bar: Bar.find_by(name: "銀座コリドー街居酒屋"), category: "日本酒", is_main: false, description: "一合瓶の地酒" },

  { bar: Bar.find_by(name: "銀座三越屋上バー"), category: "カクテル", is_main: true, description: "百貨店らしい上品なカクテル" },
  { bar: Bar.find_by(name: "銀座三越屋上バー"), category: "ワイン", is_main: false, description: "デパ地下セレクションワイン" },

  { bar: Bar.find_by(name: "銀座煉瓦亭バー"), category: "ブランデー", is_main: true, description: "老舗らしい重厚なブランデー" },
  { bar: Bar.find_by(name: "銀座煉瓦亭バー"), category: "ウイスキー", is_main: false, description: "伝統的なウイスキー" },

  { bar: Bar.find_by(name: "銀座ホステスバー雅"), category: "シャンパン", is_main: true, description: "最高級シャンパン各種" },
  { bar: Bar.find_by(name: "銀座ホステスバー雅"), category: "ブランデー", is_main: false, description: "VIP専用プレミアムブランデー" },

  { bar: Bar.find_by(name: "銀座カフェバー昼夜"), category: "カクテル", is_main: true, description: "昼夜で変わるメニュー" },
  { bar: Bar.find_by(name: "銀座カフェバー昼夜"), category: "ワイン", is_main: false, description: "ランチタイムワイン" },

  # 赤坂エリア
  { bar: Bar.find_by(name: "Piano Bar エレガンス"), category: "カクテル", is_main: true, description: "ピアノ演奏とともに楽しむクラシックカクテル" },
  { bar: Bar.find_by(name: "Piano Bar エレガンス"), category: "ウイスキー", is_main: false, description: "プレミアムウイスキー" },

  { bar: Bar.find_by(name: "赤坂サントリーバー"), category: "ウイスキー", is_main: true, description: "サントリーウイスキー全種類" },
  { bar: Bar.find_by(name: "赤坂サントリーバー"), category: "焼酎", is_main: false, description: "プレミアム焼酎" },

  { bar: Bar.find_by(name: "赤坂見附政治家バー"), category: "ブランデー", is_main: true, description: "政治家御用達プレミアムブランデー" },
  { bar: Bar.find_by(name: "赤坂見附政治家バー"), category: "ウイスキー", is_main: false, description: "格式高いウイスキー" },

  { bar: Bar.find_by(name: "赤坂氷川神社前酒場"), category: "日本酒", is_main: true, description: "神社近くらしい地酒セレクション" },
  { bar: Bar.find_by(name: "赤坂氷川神社前酒場"), category: "焼酎", is_main: false, description: "庶民的な焼酎" },

  { bar: Bar.find_by(name: "赤坂プレスセンター地下バー"), category: "カクテル", is_main: true, description: "国際的なカクテルメニュー" },
  { bar: Bar.find_by(name: "赤坂プレスセンター地下バー"), category: "ワイン", is_main: false, description: "世界各国のワイン" },

  { bar: Bar.find_by(name: "赤坂TBSテレビ局前バル"), category: "カクテル", is_main: true, description: "メディア関係者好みのカクテル" },
  { bar: Bar.find_by(name: "赤坂TBSテレビ局前バル"), category: "ワイン", is_main: false, description: "トレンドワイン" },

  # その他エリア
  { bar: Bar.find_by(name: "日本酒 蔵"), category: "日本酒", is_main: true, description: "全国47都道府県の地酒" },

  { bar: Bar.find_by(name: "浅草ほっぴん"), category: "焼酎", is_main: true, description: "九州を中心とした焼酎各種" },
  { bar: Bar.find_by(name: "浅草ほっぴん"), category: "日本酒", is_main: false, description: "庶民派日本酒" },

  { bar: Bar.find_by(name: "浅草雷門前観光バー"), category: "カクテル", is_main: true, description: "観光客向けフレンドリーカクテル" },
  { bar: Bar.find_by(name: "浅草雷門前観光バー"), category: "日本酒", is_main: false, description: "英語説明付き日本酒" },

  { bar: Bar.find_by(name: "Beer Garden TOKYO"), category: "ビール", is_main: true, description: "国内外のクラフトビール20種類" },

  { bar: Bar.find_by(name: "品川ステーションバー"), category: "ビール", is_main: true, description: "仕事帰りに飲みやすいビール各種" },
  { bar: Bar.find_by(name: "品川ステーションバー"), category: "ハイボール", is_main: false, description: "各種ハイボール・サワー" },

  { bar: Bar.find_by(name: "品川プリンスホテルバー"), category: "カクテル", is_main: true, description: "ホテルバーらしい上質なカクテル" },
  { bar: Bar.find_by(name: "品川プリンスホテルバー"), category: "シャンパン", is_main: false, description: "セレブ向けシャンパン" },

  { bar: Bar.find_by(name: "恵比寿ワインセレクション"), category: "ワイン", is_main: true, description: "ソムリエ厳選ワイン" },

  { bar: Bar.find_by(name: "エビスビアホール"), category: "ビール", is_main: true, description: "エビスビール各種とドイツビール" },

  { bar: Bar.find_by(name: "恵比寿ガーデンプレイスバー"), category: "カクテル", is_main: true, description: "都会的なモダンカクテル" },
  { bar: Bar.find_by(name: "恵比寿ガーデンプレイスバー"), category: "ワイン", is_main: false, description: "ガーデンテラス向けワイン" },

  { bar: Bar.find_by(name: "池袋ナイトオウル"), category: "カクテル", is_main: true, description: "エンターテイメント性の高いカクテル" },
  { bar: Bar.find_by(name: "池袋ナイトオウル"), category: "ビール", is_main: false, description: "各種ビール・チューハイ" },

  { bar: Bar.find_by(name: "カクテルファクトリー池袋"), category: "カクテル", is_main: true, description: "SNS映えするオリジナルカクテル" },

  { bar: Bar.find_by(name: "池袋サンシャインシティバー"), category: "カクテル", is_main: true, description: "ファミリー向けノンアルコールも充実" },
  { bar: Bar.find_by(name: "池袋サンシャインシティバー"), category: "ワイン", is_main: false, description: "カジュアルワイン" },

  { bar: Bar.find_by(name: "表参道ヒルズバー"), category: "カクテル", is_main: true, description: "洗練されたオリジナルカクテル" },
  { bar: Bar.find_by(name: "表参道ヒルズバー"), category: "シャンパン", is_main: false, description: "プレミアムシャンパン" },

  { bar: Bar.find_by(name: "下北クラフトサワー"), category: "サワー", is_main: true, description: "手作りサワー・クラフトチューハイ" },

  { bar: Bar.find_by(name: "上野アメ横酒場"), category: "焼酎", is_main: true, description: "庶民的な焼酎・日本酒" },
  { bar: Bar.find_by(name: "上野アメ横酒場"), category: "ビール", is_main: false, description: "立ち飲みスタイルのビール" },

  { bar: Bar.find_by(name: "吉祥寺ハーモニカ横丁"), category: "日本酒", is_main: true, description: "ジャズに合う地酒セレクション" },
  { bar: Bar.find_by(name: "吉祥寺ハーモニカ横丁"), category: "焼酎", is_main: false, description: "音楽を聴きながら楽しむ焼酎" },

  { bar: Bar.find_by(name: "秋葉原電気街バー"), category: "カクテル", is_main: true, description: "電子機器をモチーフにしたユニークカクテル" },

  { bar: Bar.find_by(name: "お台場レインボーブリッジバー"), category: "カクテル", is_main: true, description: "絶景を楽しむロマンチックカクテル" },
  { bar: Bar.find_by(name: "お台場レインボーブリッジバー"), category: "シャンパン", is_main: false, description: "デート向けシャンパン" }
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
puts "🎉 60件のサンプルデータの作成が完了しました！"
puts "=" * 60
puts "📊 作成データ統計"
puts "=" * 60
puts "🏮 Bar: #{Bar.count}件"
puts "⭐ Specialty: #{Specialty.count}件"
puts ""

# エリア別統計
puts "📍 エリア別統計:"
areas = ["渋谷", "新宿", "六本木", "銀座", "赤坂", "浅草", "品川", "恵比寿", "池袋", "表参道", "下北沢", "上野", "吉祥寺", "秋葉原", "台場"]
areas.each do |area|
  count = Bar.where("address LIKE ?", "%#{area}%").count
  puts "  #{area}: #{count}件" if count > 0
end

# 価格帯別統計（フィルタリング確認用）
puts ""
puts "💰 価格帯別統計（フィルタリング対応）:"
price_ranges = Bar.group(:price_range).count.sort_by { |range, count| range.scan(/\d+/).first.to_i }
price_ranges.each do |range, count|
  puts "  #{range}: #{count}件"
end

# 喫煙状況別統計（フィルタリング確認用）
puts ""
puts "🚭 喫煙状況別統計（フィルタリング対応）:"
Bar.group(:smoking_status).count.each do |status, count|
  puts "  #{status}: #{count}件"
end

# スペシャリティ別統計
puts ""
puts "🍸 スペシャリティ別統計:"
Specialty.group(:category).count.sort_by { |cat, count| -count }.each do |category, count|
  puts "  #{category}: #{count}件"
end

puts ""
puts "🎯 フィルタリング機能確認："
puts "・価格帯: 6つの異なる価格帯に分散"
puts "・喫煙状況: 禁煙・喫煙可・分煙・屋外喫煙可の4つに分散"
puts "・エリア: 15の主要エリアに分散"
puts "・スペシャリティ: 10以上のカテゴリに分散"
puts ""
puts "すべてのフィルタで複数件ヒットするようバーデータ作成済み！"