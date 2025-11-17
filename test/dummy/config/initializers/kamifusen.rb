Kamifusen.config do |config|
  config.keycdn = ENV["KAMIFUSEN_KEYCDN_HOST"].presence
  config.with_webp = ENV["KAMIFUSEN_DISABLE_WEBP"] != "true"
end
