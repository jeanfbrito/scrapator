class ScrapeProxy < ApplicationJob
  queue_as :default
  def perform
    Selenium::WebDriver::PhantomJS.path="./bin/phantomjs"
    browser = Watir::Browser.new :phantomjs

    #proxyFileName = "proxynow.txt"

    browser.goto("http://www.freeproxylists.net/?c=BR&pr=HTTPS&u=50&s=ts")
    ipXpath = "/html/body/div/div[2]/table/tbody/tr[2]/td[1]/a"
    portXpath = "/html/body/div/div[2]/table/tbody/tr[2]/td[2]"

    page_html = Nokogiri::HTML.parse(browser.html)
    ip = page_html.xpath(ipXpath).inner_text
    puts ip
    port = page_html.xpath(portXpath).inner_text
    puts port

   puts "proxy=#{ip}:#{port}"

   Setting.proxyIp = ip
   Setting.proxyPort = port

    #file = File.new("public/#{proxyFileName}", "w")
    #file.puts("#{ip}:#{port}")
    #file.close

    #file_content = File.read("public/#{proxyFileName}");
    #puts file_content;

    browser.quit
    ScrapeProxy.delay(run_at: 15.minutes.from_now).perform_later
    system "pkill -f chrome"
  end
end
