# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "------> Creating basic User \n\n"

User.create!(email: 'tester@example.com', password: '123123123')

puts "------> Creating 10 basic Scrapes \n\n"

10.times do |index|
  Scrape.create!(
    url: 'https://www.google.com.br/',
    user: User.last,
    name: "Scrape #{index}",
    xpath: '//*[@id="hplogo"]/div',
    config_value: 'Brasil'
  )
end
