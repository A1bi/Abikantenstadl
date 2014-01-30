require 'spec_helper'

describe "Profiles" do
  it 'locks profile after 14/01/31 03:00' do
    create_list(:profile_field, 3)
    Time.stub(:now).and_return(Time.mktime(2014, 2, 1, 3))
    login
    visit edit_profile_path
    expect(page).to_not have_css("textarea:not([disabled])")
    expect(page).to_not have_button(:speichern)
    expect(page).to_not have_button(:hochladen)
  end
end