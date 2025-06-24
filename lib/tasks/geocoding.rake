# lib/tasks/geocoding.rake
namespace :geocoding do
  desc "Update latitude and longitude for all bars"
  task update_coordinates: :environment do
    puts "Starting geocoding process..."
    
    geocoding_service = GeocodingService.new
    updated_count = 0
    failed_count = 0
    
    bars_without_coordinates = Bar.where(latitude: nil).or(Bar.where(longitude: nil))
    total_bars = bars_without_coordinates.count
    
    puts "Found #{total_bars} bars without coordinates"
    
    bars_without_coordinates.find_each.with_index do |bar, index|
      print "Processing #{index + 1}/#{total_bars}: #{bar.name}..."
      
      result = geocoding_service.geocode_address(bar.address)
      
      if result[:success]
        bar.update!(
          latitude: result[:latitude],
          longitude: result[:longitude]
        )
        puts " ✅ Updated (#{result[:latitude]}, #{result[:longitude]})"
        updated_count += 1
      else
        puts " ❌ Failed: #{result[:error]}"
        failed_count += 1
      end
      
      # API制限対策（1秒間に10リクエスト制限）
      sleep(0.1)
    end
    
    puts "\n" + "="*50
    puts "Geocoding completed!"
    puts "Updated: #{updated_count} bars"
    puts "Failed: #{failed_count} bars"
    puts "="*50
  end
  
  desc "Geocode a specific bar by ID"
  task :update_bar, [:bar_id] => :environment do |task, args|
    bar_id = args[:bar_id]
    
    unless bar_id
      puts "Usage: rails geocoding:update_bar[bar_id]"
      exit
    end
    
    bar = Bar.find(bar_id)
    geocoding_service = GeocodingService.new
    
    puts "Geocoding #{bar.name} (#{bar.address})..."
    
    result = geocoding_service.geocode_address(bar.address)
    
    if result[:success]
      bar.update!(
        latitude: result[:latitude],
        longitude: result[:longitude]
      )
      puts "✅ Successfully updated coordinates: (#{result[:latitude]}, #{result[:longitude]})"
    else
      puts "❌ Failed to geocode: #{result[:error]}"
    end
  end
  
  desc "Test geocoding with a sample address"
  task :test, [:address] => :environment do |task, args|
    address = args[:address] || "東京駅"
    
    puts "Testing geocoding with address: #{address}"
    
    geocoding_service = GeocodingService.new
    result = geocoding_service.geocode_address(address)
    
    if result[:success]
      puts "✅ Success!"
      puts "Latitude: #{result[:latitude]}"
      puts "Longitude: #{result[:longitude]}"
      puts "Formatted Address: #{result[:formatted_address]}"
    else
      puts "❌ Failed: #{result[:error]}"
    end
  end
  
  desc "Update all bars with random coordinates for development"
  task update_development_coordinates: :environment do
    return unless Rails.env.development?
    
    puts "Adding random coordinates for development..."
    
    # 東京都内のランダムな座標を生成
    tokyo_bounds = {
      north: 35.8986,
      south: 35.4121,
      east: 139.9093,
      west: 139.5695
    }
    
    Bar.where(latitude: nil).or(Bar.where(longitude: nil)).find_each do |bar|
      lat = rand(tokyo_bounds[:south]..tokyo_bounds[:north])
      lng = rand(tokyo_bounds[:west]..tokyo_bounds[:east])
      
      bar.update!(latitude: lat, longitude: lng)
      puts "Updated #{bar.name}: (#{lat}, #{lng})"
    end
    
    puts "Development coordinates updated!"
  end
end
