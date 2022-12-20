require 'test_helper'

class RetirementsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get retirements_new_url
    assert_response :success
  end

  test 'should get create' do
    get retirements_create_url
    assert_response :success
  end
end
