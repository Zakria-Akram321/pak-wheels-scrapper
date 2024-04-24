require 'open-uri'
require 'nokogiri'
require 'csv'

class Scrapper
  # Function to scrape the data
  def scrape_data
    puts "Please wait scrapper is running......."
    lower_range = 200000
    upper_range = 400000
    # Fetch and parse HTML document
    products = []
    29.times.each do |i|
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

  # Function to save the data into CSV file
  def make_csv_file_of_data(args)
    puts "Making a CSV file of the products........"
    # csv_file_path = Rails.root.join('public', 'csv', 'data.csv')
    rails_root = File.expand_path('../../..', __FILE__)
    csv_file_path = File.join(rails_root, 'public', 'csv', 'products.csv')
    
    CSV.open(csv_file_path, "w") do |csv|
      csv << ["Title", "Price"]
      args.each do |product|
        csv << [product[:title], product[:price]]
      end
    end
  end
end

web_scrapper = Scrapper.new

products = web_scrapper.scrape_data

web_scrapper.make_csv_file_of_data(products)


