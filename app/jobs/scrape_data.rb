class ScrapeData < ApplicationJob
  queue_as :default
  def perform(id)
    item = Scrape.find(id)
    puts item.name
    puts item.url
    puts item.xpath
    browser = Watir::Browser.new :phantomjs

    browser.goto(item.url)

    page_html = Nokogiri::HTML.parse(browser.html)
    puts page_html.xpath(item.xpath).inner_text

    browser.quit
  end
end
