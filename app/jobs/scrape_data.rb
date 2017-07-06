class ScrapeData < ApplicationJob
  require 'telegram/bot'
  require 'headless'
  queue_as :default
  def perform(id)
    #items = Scrape.where("last_read < ?", 60.minutes.ago)S
    item = Scrape.find(id)
    puts item.name
    puts item.url

    last_status = item.status
    #puts item.xpath
    #switches = ['--proxy=69.106.88.7:60199', '--proxy-auth=username:password123']
    #browser = Watir::Browser.new :phantomjs, :args => switches
    #proxyFileName = "proxynow.txt"
    #file_content = File.read("public/#{proxyFileName}");
    #puts file_content;

    proxy = "#{Setting.proxyIp}:#{Setting.proxyPort}"

    puts "using proxy: #{proxy}"

    headless = Headless.new
    headless.start

    #Selenium::WebDriver::PhantomJS.path="./bin/phantomjs"
    # browser = Watir::Browser.new( :chrome,
    #     args: "--proxy=#{proxy}"
    # )

    Selenium::WebDriver::Chrome.path = '/usr/bin/google-chrome'
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--user-data-dir=./tmp')
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    options.add_argument('--no-sandbox')
    options.add_argument("--proxy-server=#{proxy}")
    driver = Selenium::WebDriver.for :chrome, options: options

    browser = Watir::Browser.new driver
    #browser = Watir::Browser.new( :chrome, desired_capabilities: %w(--headless --disable-gpu --start-maximized --disable-web-security --disable-extensions --ignore-certificate-errors --disable-popup-blocking --disable-translate --proxy-server=m#{proxy}))

    Watir.default_timeout = 180
    #browser.window.maximize

    filename = DateTime.now.strftime("%d%b%Y%H%M%S")

    # browser.goto(item.url)
    # sleep 20
    tryLeft = 3
    begin
      puts "lets go to!"
      browser.goto(item.url)
      #browser.element(:xpath => item.xpath).wait_until_present(timeout=120)
    rescue => error
      tryLeft -= 1
      puts "something went wrong! #{error}"
      if tryLeft >= 0
        sleep 5
        retry
      end
      browser.quit
      headless.destroy
    end

    tryLeft = 6
    loop do
      tryLeft -= 1
      puts "lets search for the element now!"
      sleep 10
      break if browser.element(:xpath => item.xpath).present? || tryLeft <= 0
    end

    #browser.wait_until(15) { browser.h1.text != 'Main Page' }
    #browser.wait_until(60) { browser.text_field.exists? }
    #browser.element(:xpath => item.xpath).wait_until_present(timeout=20)

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

      if (item.status != 1 && item.status != last_status )
        if(item.user.telegramId.present?) #if telegramid not set, dont try to message with warning
          Telegram.bot.send_message chat_id: item.user.telegramId, text: "<b>Warning!</b> \nThe scrape <b>#{item.name}</b> \nNew status is <b>#{item.status}</b> \nTake a look at: #{item.url}", parse_mode: :HTML
        end
      end

      item.save
    browser.quit
    headless.destroy
  end
end
