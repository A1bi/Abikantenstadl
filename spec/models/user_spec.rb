require 'spec_helper'

describe User do
  it "should have valid factory" do
    expect(build(:user)).to be_valid
  end
  
  it "validates the presence of first_name, last_name, email" do
    user = User.new
    %w[first_name last_name email].each do |attr|
      expect(user).to have(1).error_on(attr)
    end
  end
  
  it "validates uniqueness of email" do
    user = create(:user)
    user2 = User.new(email: user.email)
    expect(user2).to have(1).error_on(:email)
  end
  
  it "sets random password and activation code" do
    user = User.new
    user.reset_password
    expect(user.password).to be_present
    expect(user.activation_code).to be_present
    p = user.password
    a = user.activation_code
    user.reset_password
    expect(user.password).to_not equal p
    expect(user.activation_code).to_not equal a
  end
end