class ScrapeData < ApplicationJob
  queue_as :default
  def perform(id)
    #items = Scrape.where("last_read < ?", 60.minutes.ago)S
    item = Scrape.find(id)
    puts item.name
    puts item.url
    #puts item.xpath
    browser = Watir::Browser.new :phantomjs

    browser.goto(item.url)

    page_html = Nokogiri::HTML.parse(browser.html)
    puts page_html.xpath(item.xpath).inner_text

    read_value = page_html.xpath(item.xpath).inner_text

    item.read_value = read_value
    item.last_read = DateTime.now

    if item.config_value == item.read_value
      item.status = 1
    else
      item.status = 2
    end

    item.save

    browser.quit
  end
end
