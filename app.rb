require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'nokogiri'
require "date"

url = "https://techracho.bpsinc.jp/category/ruby-rails-related"

page = Nokogiri::HTML(URI.open(url))

result = page.xpath("//time[@class='article-card-date']/text()")[0]
result = Time.parse(result).to_date

# 日付の取得
date = Date.today

if result > date
  p "ブログが更新されています。"
else
  p "本日の更新はありません。"
end