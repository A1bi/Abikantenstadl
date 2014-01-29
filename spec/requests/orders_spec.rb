require 'spec_helper'

describe "Orders" do
  it "saves shirt order" do
    login
    visit shirts_path
    
    expect(find_field("order_option").value).to eq("")
    
    select "M", from: :order_option
    click_button :speichern
    saved?
    expect(find_field("order_option").find('option[selected]').text).to eq("M")
    
    select "L", from: :order_option
    click_button :speichern
    expect(Order.count).to eq(1)
  end
  
  it "doesn't save invalid orders" do
    login
    visit shirts_path
    
    find("#order_item_id").set 2
    click_button :speichern
    not_saved?
    expect(Order.count).to eq(0)
    
    select "XL", from: :order_option
    click_button :speichern
    find("#order_option").set 8
    click_button :speichern
    saved?
    
    expect(find_field("order_option").find('option[selected]').text).to eq("XL")
    expect(Order.count).to eq(1)
  end
  
  def saved?(saved = true)
    expect(page).send("to" + (!saved ? "_not" : ""), have_content("erfolgreich gespeichert"))
  end
  
  def not_saved?
    saved?(false)
  end
end
