require 'spec_helper'

describe AboutUsEntry do
  it "should have valid factory" do
    expect(build(:about_us_entry)).to be_valid
  end
  
  it "validates the presence of text, user, author" do
    entry = AboutUsEntry.new
    %w[text user author].each do |attr|
      expect(entry).to have(1).error_on(attr)
    end
  end
  
  it "validates author is not user" do
    entry = AboutUsEntry.new
    entry.author = build(:user)
    entry.user = entry.author
    expect(entry).to have(1).error_on(:user)
  end
end
