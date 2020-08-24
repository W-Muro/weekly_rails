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
  date -= 1

  if result > date
    return "ブログが更新されています。"
  end
  return "本日の更新はありません。"
end