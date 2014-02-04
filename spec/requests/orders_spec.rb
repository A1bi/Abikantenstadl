require 'spec_helper'

describe "Orders" do
  it "saves shirt order" do
    login
    visit shirts_path
    
    expect(find_field("order_option").value).to eq("")
    
    order "M"
    saved?
    expect(find_field("order_option").find('option[selected]').text).to eq("M")
    
    order "L"
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
  
  it "shows all shirt orders for admins" do
    user = nil
    in_session :user do
      user = login
      visit shirts_path
      expect(page).to_not have_content("Alle Bestellungen")
    end
    
    in_session :admin do
      login(create(:admin))
      visit shirts_path
      expect(page).to have_content("Alle Bestellungen")
      expect(page).to_not have_content(user.first_name)
    end
    
    in_session :user do
      order "L"
    end
    
    in_session :admin do
      refresh
      expect(page.first(:xpath, "//tr[*[contains(.,'#{user.last_name}')]]/td[2]").text).to eq("L")
      expect(orders_for_size("L")).to eq("1")
      expect(total_orders).to eq("1")
      order "L"
      expect(orders_for_size("L")).to eq("2")
      expect(total_orders).to eq("2")
    end
  end
  
  def order(option)
    select option, from: :order_option
    click_button :speichern
  end
  
  def saved?(saved = true)
    expect(page).send("to" + (!saved ? "_not" : ""), have_content("erfolgreich gespeichert"))
  end
  
  def not_saved?
    saved?(false)
  end
  
  def orders_for_size(size)
    page.first(:xpath, "//tr[td[text()='#{size}']]/td[2]").text
  end
  
  def total_orders
    page.first(:xpath, "//tr[*[text()='Gesamt']]/td[2]").text
  end
end
