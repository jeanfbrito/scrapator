# Scrapator

## What is this for?

Do you have any website or item that you need to constantly check for any
update of status, price, of maybe version of firmware for your hardware
and everytime you need to check it manually?
So...this is why Scrapator was created!

## How to use Scrapator?

You just need to create a new "Scrap" using the GUI and provide a few infos
like: A Name, XPath (of the info on some URL/HTML page), the original value
and URL you want to check and thats it!

## What I can do with Scrapator?

You can check for changes on HTML pages, like the price of some product, or
the version of firmware of some hardware you have...the use is limitless!

## Development / Local Machine

### Installing dependencies

In order to run the project local on your machine you need to install a few
dependencies:

- Google Chrome (58 or newer)
- X11/xvfb (download XQUartz on OSX or `apt-get install xvfb` on linux)
- ChromeDriver (`brew install chromedriver` on OSX)
- Download the project and install Gems with `bin/bundle`
- Create database (`bin/rake db:create db:migrate db:seed`)

### Running the project

Now that you already installed the dependencies just run:
- bin/rails s

### Testing the Project

- Manually: just create a new Scrap
- Automatic: we need to implement RSpec...(PRs are welcome)

## Other informations
Things you may want to cover:

* Ruby version 3.4.1

* System dependencies PhantomJS

* Configuration
https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app

Simply do
heroku buildpacks:add --index 1 https://github.com/stomita/heroku-buildpack-phantomjs

And deploy. Worked for me on Phantom 2.1.1

* Database creation

* Database initialization
heroku run rake db:migrate

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

* App to extract XPath on HTML
https://chrome.google.com/webstore/detail/xpath-helper/hgimnogjllphhhkhlmebbmlgjoejdpjl

https://www.sslproxies.org/

nohup rake jobs:work &
 nohup: ignoring input and appending output to `nohup.out'
