require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class Logo < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://automationpractice.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_logo
    @driver.get(@base_url + "/index.php?id_category=5&controller=category")
    @driver.find_element(:css, "img.logo.img-responsive").click
    @driver.find_element(:xpath, "//img[@alt='Blouse']").click
    @driver.find_element(:css, "img.logo.img-responsive").click
    @driver.find_element(:link, "Contact us").click
    @driver.find_element(:css, "img.logo.img-responsive").click
    @driver.find_element(:link, "My orders").click
    @driver.find_element(:css, "img.logo.img-responsive").click
  end
  
  def element_present?(how, what)
    ${receiver}.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = ${receiver}.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
