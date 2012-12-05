include ApplicationHelper

def match_alert(subject, level, message)
  subject.should have_selector("div.alert.alert-#{level}", text: message)
end

RSpec::Matchers.define :have_success do |expected|
  match do |actual|
    match_alert(actual, 'success', expected)
  end
end

RSpec::Matchers.define :have_notice do |expected|
  match do |actual|
    match_alert(actual, 'notice', expected)
  end
end

RSpec::Matchers.define :have_error do |expected|
  match do |actual|
    match_alert(actual, 'error', expected)
  end
end

def browser
  page.driver.browser
end

RSpec::Matchers.define :eql_element_property_value do |element, property|
  match do |subject|
    @value = browser.find_element(:css, element).css_value(property)
    subject.should == @value
  end

  failure_message_for_should do |actual|
    "expected that element #{element}'s CSS property #{property} should be #{actual}, but was #{@value}"
  end

  failure_message_for_should_not do |actual|
    "expected that element #{element}'s CSS property #{property} should not be #{actual}"
  end
end

def signin(user)
  visit signin_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
