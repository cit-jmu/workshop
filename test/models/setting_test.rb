require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  test "settings require a name" do
    setting = Setting.new
    setting.value = "testvalue"
    assert setting.invalid?
    assert_equal ["can't be blank"], setting.errors[:name]
  end

  test "setting names are unique" do
    setting = Setting.new
    setting.name = settings(:test_setting).name
    setting.value = "testvalue"
    assert setting.invalid?
    assert_equal ["has already been taken"], setting.errors[:name]
  end

  test "settings allow blank values" do
    setting = Setting.new
    setting.name = "testblank"
    setting.value = ""
    assert setting.valid?
  end

  test "settings track the user who last modified them" do
    setting = Setting.new(name: "testsetting", value: "testvalue")
    setting.last_changed_by = 'a_user'
    setting.save
    assert_equal "a_user", setting.last_changed_by
  end

  test "settings default to being changed by 'system'" do
    setting = Setting.new(name: "testsetting", value: "testvalue")
    setting.save
    assert_equal "system", setting.last_changed_by
  end
end
