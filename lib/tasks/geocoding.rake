namespace :geocoding do
  desc "Update latitude and longitude for all bars"
  task update_coordinates: :environment do
    puts "🗺️  Bar-Atlas Geocoding 開始..."
    puts "=" * 50

    updated_count = 0
    failed_count = 0
    failed_bars = []

    bars_without_coordinates = Bar.where(latitude: nil).or(Bar.where(longitude: nil))
    total_bars = bars_without_coordinates.count

    puts "📊 対象バー数: #{total_bars}件"
    puts ""

    if total_bars == 0
      puts "✅ すべてのバーに座標が設定済みです！"
      return
    end

    # API接続テスト
    puts "🔌 Google Maps API 接続テスト..."
    begin
      geocoding_service = GeocodingService.new
      test_result = geocoding_service.geocode_address("東京駅")

      if test_result[:success]
        puts "✅ API接続成功！"
        puts "  テスト座標: (#{test_result[:latitude]}, #{test_result[:longitude]})"
      else
        puts "❌ API接続失敗: #{test_result[:error]}"
        puts "環境変数 GOOGLE_MAPS_API_KEY を確認してください"
        return
      end
    rescue => e
      puts "❌ API初期化エラー: #{e.message}"
      return
    end
    puts ""

    geocoding_service = GeocodingService.new

    # 座標取得開始
    puts "🚀 座標取得開始..."
    bars_without_coordinates.find_each.with_index do |bar, index|
      print "[#{index + 1}/#{total_bars}] #{bar.name}"
      puts "  📍 #{bar.address}"

      begin
        result = geocoding_service.geocode_address(bar.address)

        if result[:success]
          bar.update!(
            latitude: result[:latitude],
            longitude: result[:longitude]
          )
          puts "  ✅ 成功: (#{result[:latitude]}, #{result[:longitude]})"
          puts "  📝 住所: #{result[:formatted_address]}" if result[:formatted_address]
          updated_count += 1
        else
          puts "  ❌ 失敗: #{result[:error]}"
          failed_count += 1
          failed_bars << {
            name: bar.name,
            address: bar.address,
            error: result[:error]
          }
        end
      rescue => e
        puts "  ⚠️  例外エラー: #{e.message}"
        failed_count += 1
        failed_bars << {
          name: bar.name,
          address: bar.address,
          error: e.message
        }
      end

      # API制限対策
      sleep(0.1)
      puts ""
    end

    # 結果レポート
    puts ""
    puts "🎉 Geocoding 処理完了！"
    puts "=" * 50
    puts "📈 結果統計:"
    puts "  成功: #{updated_count}件"
    puts "  失敗: #{failed_count}件"
    puts "  成功率: #{updated_count > 0 ? (updated_count.to_f / total_bars * 100).round(1) : 0}%"
    puts ""

    # 最終統計
    final_geocoded_count = Bar.where.not(latitude: nil, longitude: nil).count
    total_bars_final = Bar.count
    puts "📍 最終状況:"
    puts "  座標設定済み: #{final_geocoded_count}/#{total_bars_final}件"
    puts "  完了率: #{(final_geocoded_count.to_f / total_bars_final * 100).round(1)}%"
    puts ""

    # 成功例表示
    if final_geocoded_count > 0
      puts "✅ 座標取得成功例 (最初の5件):"
      Bar.where.not(latitude: nil, longitude: nil).limit(5).each do |bar|
        puts "  #{bar.name}: (#{bar.latitude}, #{bar.longitude})"
      end
      puts ""
    end

    # 失敗詳細
    if failed_bars.any?
      puts "⚠️  座標取得に失敗したバー:"
      failed_bars.each_with_index do |failed_bar, index|
        puts "  #{index + 1}. #{failed_bar[:name]}"
        puts "     住所: #{failed_bar[:address]}"
        puts "     エラー: #{failed_bar[:error]}"
        puts ""
      end

      puts "💡 対策案:"
      puts "  1. 住所を修正して再実行: rails geocoding:update_bar[ID]"
      puts "  2. 手動座標設定も可能"
    end

    puts "🗺️  Web画面でGoogle Maps表示を確認してください！"
  end

  desc "Geocode a specific bar by ID"
  task :update_bar, [:bar_id] => :environment do |task, args|
    bar_id = args[:bar_id]
    unless bar_id
      puts "使用方法: rails geocoding:update_bar[bar_id]"
      exit
    end

    bar = Bar.find(bar_id)
    puts "🗺️  #{bar.name} の座標取得中..."
    puts "住所: #{bar.address}"

    begin
      geocoding_service = GeocodingService.new
      result = geocoding_service.geocode_address(bar.address)

      if result[:success]
        bar.update!(
          latitude: result[:latitude],
          longitude: result[:longitude]
        )
        puts "✅ 座標更新成功!"
        puts "  座標: (#{result[:latitude]}, #{result[:longitude]})"
        puts "  整形住所: #{result[:formatted_address]}" if result[:formatted_address]
      else
        puts "❌ 座標取得失敗: #{result[:error]}"
      end
    rescue => e
      puts "❌ エラー: #{e.message}"
    end
  end

  desc "Test geocoding with a sample address"
  task :test, [:address] => :environment do |task, args|
    address = args[:address] || "東京駅"
    puts "🔍 テスト住所: #{address}"

    begin
      geocoding_service = GeocodingService.new
      result = geocoding_service.geocode_address(address)

      if result[:success]
        puts "✅ Geocoding成功!"
        puts "  緯度: #{result[:latitude]}"
        puts "  経度: #{result[:longitude]}"
        puts "  整形住所: #{result[:formatted_address]}"
      else
        puts "❌ Geocoding失敗: #{result[:error]}"
      end
    rescue => e
      puts "❌ エラー: #{e.message}"
    end
  end

  desc "Test reverse geocoding with coordinates"
  task :reverse_test, [:lat, :lng] => :environment do |task, args|
    lat = args[:lat] || "35.6762"
    lng = args[:lng] || "139.6503"
    puts "🔍 逆ジオコーディングテスト: (#{lat}, #{lng})"

    begin
      geocoding_service = GeocodingService.new
      result = geocoding_service.reverse_geocode(lat.to_f, lng.to_f)

      if result[:success]
        puts "✅ 逆ジオコーディング成功!"
        puts "  住所: #{result[:address]}"
      else
        puts "❌ 逆ジオコーディング失敗: #{result[:error]}"
      end
    rescue => e
      puts "❌ エラー: #{e.message}"
    end
  end

  desc "Check geocoding status and API health"
  task status: :environment do
    puts "📊 Geocoding 状況レポート"
    puts "=" * 40

    # バー統計
    total = Bar.count
    with_coords = Bar.where.not(latitude: nil, longitude: nil).count
    without_coords = total - with_coords

    puts "🏮 バー統計:"
    puts "  総数: #{total}件"
    puts "  座標設定済み: #{with_coords}件"
    puts "  座標未設定: #{without_coords}件"
    puts "  設定率: #{total > 0 ? ((with_coords.to_f / total) * 100).round(1) : 0}%"
    puts ""

    # API接続確認
    puts "🔌 API接続確認:"
    begin
      geocoding_service = GeocodingService.new
      test_result = geocoding_service.geocode_address("東京駅")
      
      if test_result[:success]
        puts "  ✅ Google Maps API: 正常"
        puts "  🗝️  APIキー: 設定済み"
      else
        puts "  ❌ Google Maps API: エラー - #{test_result[:error]}"
      end
    rescue => e
      puts "  ❌ API初期化失敗: #{e.message}"
    end
    puts ""

    # 座標範囲確認
    if with_coords > 0
      min_lat = Bar.where.not(latitude: nil).minimum(:latitude)
      max_lat = Bar.where.not(latitude: nil).maximum(:latitude)
      min_lng = Bar.where.not(longitude: nil).minimum(:longitude)
      max_lng = Bar.where.not(longitude: nil).maximum(:longitude)
      center_lat = ((min_lat + max_lat) / 2).round(6)
      center_lng = ((min_lng + max_lng) / 2).round(6)

      puts "📍 座標範囲:"
      puts "  緯度: #{min_lat} 〜 #{max_lat}"
      puts "  経度: #{min_lng} 〜 #{max_lng}"
      puts "  中心点: (#{center_lat}, #{center_lng})"
      puts ""
    end

    # 未設定バー一覧
    if without_coords > 0
      puts "⚠️  座標未設定のバー (最大10件):"
      Bar.where(latitude: nil).or(Bar.where(longitude: nil)).limit(10).each_with_index do |bar, index|
        puts "  #{index + 1}. #{bar.name}"
        puts "     住所: #{bar.address}"
        puts "     ID: #{bar.id}"
      end
      puts ""
      puts "🔧 実行コマンド:"
      puts "  全件: rails geocoding:update_coordinates"
      puts "  個別: rails geocoding:update_bar[ID]"
    else
      puts "✅ すべてのバーに座標が設定済みです！"
    end
  end

  desc "Emergency: Add random coordinates for development (Tokyo area)"
  task add_random_coordinates: :environment do
    return unless Rails.env.development?

    puts "🎲 開発用ランダム座標追加中..."

    # 東京都心部の範囲
    tokyo_bounds = {
      north: 35.7500,   # 北: 池袋付近
      south: 35.6000,   # 南: 品川付近 
      east: 139.8000,   # 東: 江戸川区付近
      west: 139.6000    # 西: 世田谷区付近
    }

    updated_count = 0
    Bar.where(latitude: nil).or(Bar.where(longitude: nil)).find_each do |bar|
      lat = rand(tokyo_bounds[:south]..tokyo_bounds[:north])
      lng = rand(tokyo_bounds[:west]..tokyo_bounds[:east])

      bar.update!(latitude: lat, longitude: lng)
      puts "📍 #{bar.name}: (#{lat.round(6)}, #{lng.round(6)})"
      updated_count += 1
    end

    puts "🎉 #{updated_count}件の座標を追加しました（開発用ランダム座標）"
    puts "⚠️  本番環境では rails geocoding:update_coordinates を使用してください"
  end
end
