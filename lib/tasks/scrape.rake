
namespace :scrape do
  desc "start scheduling scrapes"
  task start: :environment do
    ScrapeProxy.new.delay.perform
    ScheduleScrapes.new.delay.perform
  end

  task proxy: :environment do
    ScrapeProxy.new.delay.perform
  end

end
