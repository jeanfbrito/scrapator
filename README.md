# README

This README would normally document whatever steps are necessary to get the
application up and running.

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
