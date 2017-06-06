require 'test_helper'

class ScrapesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scrape = scrapes(:one)
  end

  test "should get index" do
    get scrapes_url
    assert_response :success
  end

  test "should get new" do
    get new_scrape_url
    assert_response :success
  end

  test "should create scrape" do
    assert_difference('Scrape.count') do
      post scrapes_url, params: { scrape: { config_value: @scrape.config_value, last_read: @scrape.last_read, name: @scrape.name, read_value: @scrape.read_value, status: @scrape.status, url: @scrape.url, xpath: @scrape.xpath } }
    end

    assert_redirected_to scrape_url(Scrape.last)
  end

  test "should show scrape" do
    get scrape_url(@scrape)
    assert_response :success
  end

  test "should get edit" do
    get edit_scrape_url(@scrape)
    assert_response :success
  end

  test "should update scrape" do
    patch scrape_url(@scrape), params: { scrape: { config_value: @scrape.config_value, last_read: @scrape.last_read, name: @scrape.name, read_value: @scrape.read_value, status: @scrape.status, url: @scrape.url, xpath: @scrape.xpath } }
    assert_redirected_to scrape_url(@scrape)
  end

  test "should destroy scrape" do
    assert_difference('Scrape.count', -1) do
      delete scrape_url(@scrape)
    end

    assert_redirected_to scrapes_url
  end
end
