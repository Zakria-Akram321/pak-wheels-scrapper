require 'open-uri'
require 'nokogiri'
require 'csv'

class Scrapper
  def scrape_data
    puts "Please wait scrapper is running......."
    lower_range = 200000
    upper_range = 400000
    # Fetch and parse HTML document
    products = []
    28.times.each do |i|
      doc = Nokogiri::HTML(URI.open("https://www.pakwheels.com/used-cars/search/-/pr_#{lower_range}_#{upper_range}/?page=#{i+1}"))

      # Search for nodes by css
      all_products_container = doc.css('.search-page-new div.search-listing')
      all_products_container.each do |product|
        titles = product.css('ul.search-results li.classified-listing div.search-title-row a h3').map {|title| title.text.strip}
        prices = product.css('ul.search-results li.classified-listing div.search-title-row .price-details').map {|price| price.text.strip}

        titles.length.times.each do |j|
          single_product = {title: titles[j], price: prices[j]}
          products << single_product
        end
      end
    end
    return products
  end
end

web_scrapper = Scrapper.new

products = web_scrapper.scrape_data

p products

