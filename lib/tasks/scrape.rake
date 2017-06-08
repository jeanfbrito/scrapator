
namespace :scrape do
  desc "TODO"
  task test: :environment do
      item = Scrape.find(2)
      puts item.name
      puts item.url
      puts item.xpath
      browser = Watir::Browser.new :phantomjs

      browser.goto(item.url)

      page_html = Nokogiri::HTML.parse(browser.html)
      puts page_html.xpath(item.xpath).inner_text

      browser.quit
  end

  task start: :environment do
    ScheduleScrapes.new.delay.perform
  end

end
