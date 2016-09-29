require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class Search < Test::Unit::TestCase

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
  
  def test_search
    @driver.get(@base_url + "/index.php")
    @driver.find_element(:id, "search_query_top").clear
    @driver.find_element(:id, "search_query_top").send_keys "short"
    @driver.find_element(:name, "submit_search").click
    # Warning: verifyTextNotPresent may require manual changes
    verify { assert_no_match /^[\s\S]*css=span\.heading-counter[\s\S]*$/, @driver.find_element(:css, "BODY").text }
    @driver.find_element(:xpath, "(//a[contains(text(),'Faded Short Sleeve T-shirts')])[2]").click
    # Warning: verifyTextPresent may require manual changes
    verify { assert_match /^[\s\S]*\/\/div\[@id='center_column'\]\/div\/section\/table\/tbody\/tr\[3\]\/td\[2\][\s\S]*$/, @driver.find_element(:css, "BODY").text }
    @driver.find_element(:link, "Back to Search results for \"short\" (4 other results)").click
    @driver.find_element(:id, "search_query_top").clear
    @driver.find_element(:id, "search_query_top").send_keys "shortL"
    @driver.find_element(:name, "submit_search").click
    # Warning: verifyTextPresent may require manual changes
    verify { assert_match /^[\s\S]*css=p\.alert\.alert-warning[\s\S]*$/, @driver.find_element(:css, "BODY").text }
    # Warning: verifyTextPresent may require manual changes
    verify { assert_match /^[\s\S]*css=span\.heading-counter[\s\S]*$/, @driver.find_element(:css, "BODY").text }
    # ERROR: Caught exception [unknown command []]
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
