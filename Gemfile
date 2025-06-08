source "https://rubygems.org"
ruby "3.3.3"

# Core Rails gems
gem "rails", "~> 7.1.3"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Frontend & JavaScript
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

# Application features
gem "ransack"       # Search functionality
gem "devise"        # User authentication

# System gems
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Uncomment for production features
# gem "redis", ">= 4.0.1"
# gem "kredis"
# gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri windows ]

  # Testing framework
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"

  # Integration testing
  gem "capybara"
  gem "selenium-webdriver"
end

group :development do
  # Development tools
  gem "web-console"

  # Code quality
  gem "rubocop", require: false
  gem "rubocop-rails", require: false

  # Performance monitoring
  gem "bullet"          # N+1 query detection

  # Environment management
  gem "dotenv-rails"    # Environment variables

  # Uncomment for performance profiling
  # gem "rack-mini-profiler"
  # gem "spring"
end