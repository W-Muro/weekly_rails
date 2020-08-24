require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'nokogiri'
require "date"

def check_weekly_rails
  url = "https://techracho.bpsinc.jp/category/ruby-rails-related"

  page = Nokogiri::HTML(URI.open(url))

  result = page.xpath("//time[@class='article-card-date']/text()")[0]
  result = Time.parse(result).to_date

  # 日付の取得
  date = Date.today

  if result > date
    return "ブログが更新されています。"
  end
  return "本日の更新はありません。"
end

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  end

  "OK"
end

get '/' do
  res = check_weekly_rails
  return res
end