class ScrapeData < ApplicationJob
  require 'telegram/bot'
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

    puts proxy

    Selenium::WebDriver::PhantomJS.path="./bin/phantomjs"
    browser = Watir::Browser.new( :phantomjs,
        args: "--proxy=#{proxy}"
    )

    filename = DateTime.now.strftime("%d%b%Y%H%M%S")

    #browser.goto(item.url)
    tryLeft = 3
    begin
      browser.goto(item.url)
    rescue => error
      tryLeft -= 1

      if tryLeft >= 0
        sleep 10
        retry
      end
      Timeout::timeout(2) { browser.close }
    end

    #browser.wait_until(15) { browser.h1.text != 'Main Page' }
    #browser.wait_until(60) { browser.text_field.exists? }
    tryLeft = 3
    begin
      browser.element(:xpath => item.xpath).wait_until_present(timeout=20)
    rescue
      puts "NOT FOUND! Waited twenty seconds without seeing the xpath"
      tryLeft -= 1

      if tryLeft >= 0
        sleep 10
        retry
      end
    end

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
      #Telegram.bot.send_message chat_id: item.user.telegramId, text: "Warning! \nThe scrape <b>#{item.name}</b> \nNew status is <b>#{item.status}</b> \nTake a look: #{item.url}", parse_mode: :HTML
      if(item.user.telegramId.present?) #if telegramid not set, dont try to message with warning
        Telegram.bot.send_message chat_id: item.user.telegramId, text: "<b>Warning!</b> \nThe scrape <b>#{item.name}</b> \nNew status is <b>#{item.status}</b> \nTake a look at: #{item.url}", parse_mode: :HTML
      end
    end

    item.save

    browser.quit
  end
end
