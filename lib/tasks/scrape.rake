
namespace :scrape do
  desc "start scheduling scrapes"
  task start: :environment do
    ScheduleScrapes.new.delay.perform
  end

end
