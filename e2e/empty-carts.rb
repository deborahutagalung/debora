require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class AddAvailableItem < Test::Unit::TestCase

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
  
  def test_add_available_item
    @driver.get "http://automationpractice.com/index.php?id_product=4&controller=product#/size-l/color-beige"
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "group_1")).select_by(:text, "M")
    @driver.find_element(:css, "option[title=\"M\"]").click
    assert element_present?(:id, "availability_value")
    @driver.find_element(:css, "i.icon-plus").click
    @driver.find_element(:css, "i.icon-minus").click
    # ERROR: Caught exception [ERROR: Unsupported command [getEval | id=quantity_wanted | ]]
    @driver.find_element(:css, "i.icon-plus").click
    @driver.find_element(:name, "Submit").click
    # Warning: assertTextPresent may require manual changes
    assert_match /^[\s\S]*Product successfully added to your shopping cart [\s\S]*$/, @driver.find_element(:css, "BODY").text
    @driver.find_element(:xpath, "//div[@id='layer_cart']/div/div[2]/div[4]/a/span").click
    @driver.get "http://automationpractice.com/index.php?controller=order"
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
