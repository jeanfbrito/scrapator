require 'watir'
require 'nokogiri'

browser = Watir::Browser.new :phantomjs

browser.goto('http://www.samsung.com/br/support/model/UN49KU6400GXZD/')

page_html = Nokogiri::HTML.parse(browser.html)
puts page_html.xpath("/html/body/div[@id='wrap']/div[@id='content']/section[@class='support-z']/div[@class='pdp-contents']/div[@class='par parsys']/div[@class='section sp-g-pdp-manualdownload']/div[@class='pdp-row has-cols acont has-fitem bg1']/div[@id='listingZone2']/div[@class='mt-z']/div[@class='pixed-in']/div[@class='tbl-ly']/div[@class='cont-cols pro-info fixed-right']/div[@id='resultDiv']/div[@class='if-box'][2]/ul[@class='if-cont']/li[@class='if-row fst']/div[@class='if-file if-cell']/a[@class='if-down']/span[@class='if-q']").inner_text

browser.quit
