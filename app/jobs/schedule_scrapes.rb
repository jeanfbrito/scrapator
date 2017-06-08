class ScheduleScrapes < ApplicationJob
  queue_as :default
  def perform
    items = Scrape.where("last_read < ?", 30.minutes.ago)
    items.each do |item|
      ScrapeData.new.delay.perform(item.id)
      puts item.id
    end
    ScheduleScrapes.delay(run_at: 5.minutes.from_now).perform_later
  end
end
