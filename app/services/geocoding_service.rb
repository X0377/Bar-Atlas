require 'httparty'

class GeocodingService
  include HTTParty
  base_uri 'https://maps.googleapis.com'

  def initialize
    @api_key = Rails.application.credentials.dig(:google_maps, :api_key) || ENV['GOOGLE_MAPS_API_KEY']
    raise 'Google Maps API key not found' unless @api_key
  end

  def geocode_address(address)
    Rails.logger.info "Geocoding address: #{address}"

    response = self.class.get('/maps/api/geocode/json', {
      query: {
        address: address,
        key: @api_key,
        language: 'ja',
        region: 'JP'
      }
    })

    if response.success?
      result = response.parsed_response

      if result['status'] == 'OK' && result['results'].any?
        location = result['results'].first['geometry']['location']
        {
          latitude: location['lat'],
          longitude: location['lng'],
          formatted_address: result['results'].first['formatted_address'],
          success: true
        }
      else
        Rails.logger.warn "Geocoding failed for #{address}: #{result['status']}"
        { success: false, error: result['status'] }
      end
    else
      Rails.logger.error "Geocoding API request failed: #{response.code}"
      { success: false, error: 'API request failed' }
    end
  rescue StandardError => e
    Rails.logger.error "Geocoding error: #{e.message}"
    { success: false, error: e.message }
  end

  def reverse_geocode(latitude, longitude)
    response = self.class.get('/maps/api/geocode/json', {
      query: {
        latlng: "#{latitude},#{longitude}",
        key: @api_key,
        language: 'ja',
        region: 'JP'
      }
    })

    if response.success?
      result = response.parsed_response

      if result['status'] == 'OK' && result['results'].any?
        {
          address: result['results'].first['formatted_address'],
          success: true
        }
      else
        { success: false, error: result['status'] }
      end
    else
      { success: false, error: 'API request failed' }
    end
  rescue StandardError => e
    Rails.logger.error "Reverse geocoding error: #{e.message}"
    { success: false, error: e.message }
  end
end
