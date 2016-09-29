require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class SignUp < Test::Unit::TestCase

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
  
  def test_sign_up
    @driver.get(@base_url + "/index.php")
    verify { assert element_present?(:link, "Sign in") }
    @driver.find_element(:link, "Sign in").click
    @driver.find_element(:id, "email_create").click
    @driver.find_element(:id, "email_create").clear
    @driver.find_element(:id, "email_create").send_keys "debfictive+x@gmail.com"
    @driver.find_element(:id, "SubmitCreate").click
    @driver.find_element(:id, "id_gender2").click
    @driver.find_element(:id, "customer_firstname").clear
    @driver.find_element(:id, "customer_firstname").send_keys "Debo"
    @driver.find_element(:id, "customer_lastname").clear
    @driver.find_element(:id, "customer_lastname").send_keys "Again"
    @driver.find_element(:id, "passwd").clear
    @driver.find_element(:id, "passwd").send_keys "Password2go"
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "days")).select_by(:text, "regexp:10\\s+")
    @driver.find_element(:css, "option[value=\"10\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "months")).select_by(:text, "regexp:May\\s")
    @driver.find_element(:css, "#months > option[value=\"5\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "years")).select_by(:text, "regexp:1998\\s+")
    @driver.find_element(:css, "option[value=\"1998\"]").click
    @driver.find_element(:id, "newsletter").click
    @driver.find_element(:id, "optin").click
    @driver.find_element(:id, "company").clear
    @driver.find_element(:id, "company").send_keys "Salestock"
    @driver.find_element(:id, "address1").clear
    @driver.find_element(:id, "address1").send_keys "Jakarta Raya"
    @driver.find_element(:id, "submitAccount").click
    @driver.find_element(:id, "city").clear
    @driver.find_element(:id, "city").send_keys "Jakarta"
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "id_state")).select_by(:text, "Alabama")
    @driver.find_element(:css, "#id_state > option[value=\"1\"]").click
    @driver.find_element(:id, "postcode").clear
    @driver.find_element(:id, "postcode").send_keys "12314"
    @driver.find_element(:css, "#id_country > option[value=\"21\"]").click
    @driver.find_element(:id, "phone_mobile").clear
    @driver.find_element(:id, "phone_mobile").send_keys "456789"
    @driver.find_element(:id, "alias").clear
    @driver.find_element(:id, "alias").send_keys "Address"
    @driver.find_element(:id, "submitAccount").click
    @driver.find_element(:id, "passwd").clear
    @driver.find_element(:id, "passwd").send_keys "Password2go"
    @driver.find_element(:id, "submitAccount").click
    verify { assert element_present?(:link, "Sign out") }
    verify { assert !element_present?(:link, "Sign in") }
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
