require 'telegram/bot'
require 'headless'

class ScrapeData < ApplicationJob
  queue_as :default

  def perform(id)
    item = Scrape.find(id)

    puts "Scraping -> #{item.name} -> URL: #{item.url}"

    proxy = "#{Setting.proxyIp}:#{Setting.proxyPort}"
    last_status = item.status

    puts "using proxy: #{proxy}"

    #headless = Headless.new
    #headless.start

    # options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--user-data-dir=./tmp')
    # options.add_argument('--ignore-certificate-errors')
    # options.add_argument('--disable-popup-blocking')
    # options.add_argument('--disable-translate')
    # options.add_argument('--no-sandbox')
    # #options.add_argument('--headless')
    # #options.add_argument('--disable-gpu')
    # options.add_argument("--proxy-server=#{proxy}")

    #Watir.default_timeout = 180

    @browser = Watir::Browser.new :chrome, :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate --disable-notifications --start-maximized --disable-gpu --headless --proxy-server=#{proxy}]
    @browser.driver.manage.timeouts.implicit_wait = 180 # seconds

    # begin
    #   @browser = Watir::Browser.new(Selenium::WebDriver.for(:chrome, options: options))
    #   puts "browser created"
    # rescue
    #   system "pkill -f chrome"
    #   @browser.quit
    #   headless.destroy
    # end


@browser.goto(item.url)

    tryLeft = 3
    begin
      puts "lets go to: #{item.url}"
      @browser.goto(item.url)
      if(@browser.url == item.url)
        tryElementLeft = 6
        loop do
          tryElementLeft -= 1
          sleep 10
          puts "lets search for the element now!"
          break if @browser.element(:xpath => item.xpath).present? || tryElementLeft <= 0
        end
      else
        raise "error"
      end
    rescue => error
      tryLeft -= 1
      puts "something went wrong! #{error}"
      if tryLeft >= 0
        sleep 5
        retry
      end
      @browser.quit
      #headless.destroy
    end


    if(item.screenshot?)
      File.delete("public/screenshots/#{item.screenshot}") if File.exist?("public/screenshots/#{item.screenshot}")
    end

    filename = DateTime.now.strftime("%d%b%Y%H%M%S")
    @browser.screenshot.save("public/screenshots/#{filename}.png")
    item.screenshot = "#{filename}.png"

    # Before read the final value, run the previous steps
    execute_steps(item.scrape_steps) if item.scrape_steps.any?
    page_html = Nokogiri::HTML.parse(@browser.html)
    # Now read the goal value
    read_value = page_html.xpath(item.xpath).inner_text
    puts read_value

    # Assign the correct value for the Scrape
    item.read_value = read_value
    item.last_read = DateTime.now

    # Check if goal value has changed
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

    # Save and finish browser
    item.save
    @browser.quit
    #headless.destroy
  end

  private

  def execute_steps(steps)
    puts "Executing Steps..."
    steps.each do |step|
      click(step.xpath) if step.option == 'click'
      select(step.xpath, step.value) if step.option == 'select value'
      fill_in(step.xpath, step.value) if step.option == 'fill in'
    end
  end

  def click(xpath)
    puts "Clicking on '#{xpath}'"
    @browser.element(:xpath, xpath).click
  end

  def fill_in(xpath, value)
    puts "Filling '#{value}' on '#{xpath}'"
    @browser.text_field(xpath: xpath).set(value)
  end

  def select(xpath, value)
    puts "Selecting '#{value}' on '#{xpath}'"
    @browser.select_list(:xpath, xpath).option(text: value).select
  end
end
