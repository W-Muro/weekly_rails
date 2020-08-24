# rake scheduler:call_check_weekly_rails で実行（環境変数があるのでこのままでは動きません）
require "./ruby/scraping.rb"
require 'net/http'
require 'uri'
require 'json'


namespace :scheduler do
  desc "This task is called check_weekly_rails by the GAS"
  task :call_check_weekly_rails do
    res = check_weekly_rails

    uri = URI.parse("https://api.line.me/v2/bot/message/broadcast")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer {#{ENV["LINE_CHANNEL_TOKEN"]}}"
    request.body = JSON.dump({
      "messages" => [
        {
          "type" => "text",
          "text" => res
        }
      ]
    })
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end
end