class ScrapeData < ApplicationJob
  queue_as :default
  def perform(id)
    #items = Scrape.where("last_read < ?", 60.minutes.ago)S
    item = Scrape.find(id)
    puts item.name
    puts item.url
    #puts item.xpath
    #switches = ['--proxy=69.106.88.7:60199', '--proxy-auth=username:password123']
    #browser = Watir::Browser.new :phantomjs, :args => switches
    Selenium::WebDriver::PhantomJS.path="../../bin/phantomjs"
    browser = Watir::Browser.new( :phantomjs,
        args: '--proxy=177.99.161.60:3128'
    )

    filename = DateTime.now.strftime("%d%b%Y%H%M%S")

    browser.goto(item.url)
    browser.wait_until { browser.h1.text != 'Main Page' }
    if(item.screenshot?)
      File.delete("public/screenshots/#{item.screenshot}") if File.exist?("public/screenshots/#{item.screenshot}")
    end
    browser.screenshot.save ("public/screenshots/#{filename}.png")
    #file = File.new("public/html/#{filename}.html", "w")
    #file.puts(browser.html)
    #file.close

    item.screenshot = "#{filename}.png"

    page_html = Nokogiri::HTML.parse(browser.html)
    puts page_html.xpath(item.xpath).inner_text

    read_value = page_html.xpath(item.xpath).inner_text

    item.read_value = read_value
    item.last_read = DateTime.now

    if item.config_value.strip == item.read_value.strip
      item.status = 1
      puts "similar"
    elsif item.read_value.strip == ''
      item.status = 3
      puts "not found"
    else
      item.status = 2
      puts "changed"
    end

    item.save

    browser.quit
  end
end
