require 'open-uri'
require 'nokogiri'
require 'csv'

######### class, id
columnArticle = ".zn__column--idx-2"
columnArticleItem = ".zn__column--idx-2 article .cd__content .cd__headline"
articleTag = "article"
articleLink = "article .link-banner"
articleTitle = ".pg-headline"
articleDate = ".update-time"
articleAuthor = ".metadata__byline__author a:nth-child(1)"
articleImage = "article div img @src"
articleText = "#body-text"
articlePar = ".zn-body__paragraph"
#########

puts "Enter link to CNN article"
url = gets.chomp

if not url.include? "https://edition.cnn.com/"
    puts "Invalid link"
    exit(1)
end

doc = Nokogiri::HTML(open(url), nil) 

dataSet = []

# get title
title = doc.css(articleTitle).inner_html.strip
puts title
dataSet.push(title)

# get date
date = doc.css(articleDate).inner_html.strip
puts date
dataSet.push(date)

# get author
author = doc.css(articleAuthor).inner_html.strip
puts author
dataSet.push(author)

# get image
image = doc.css(articleImage).first.inner_html.strip
puts image
dataSet.push(image)

# get text
text = ""
doc.css(articleText).each do |block|
    text += block.css(articlePar).inner_html.strip;
end

dataSet.push(text)

CSV.open('cnn_data.csv', "w") do |csv|
  csv << dataSet
end