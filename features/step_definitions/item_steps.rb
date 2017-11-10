When /^I select "([^"\/]*)\/([^"\/]*)\/([^"\/]*)" as the date for "([^"]*)"$/ do |year,month,day,field|
  select(year, :from => "item_"+field+"_1i")
  select(month, :from => "item_"+field+"_2i")
  select(day, :from => "item_"+field+"_3i")
end

Given /the following items exist/ do |items_table|
  items_table.hashes.each do |item|
    Item.create!(item)
  end
end

Then /^I should (not )?see "(.*)" before "(.*)"$/ do |not_see, e1, e2|
  if not_see
    expect(page.body.index(e1)).to be > page.body.index(e2)
  else
    expect(page.body.index(e1)).to be < page.body.index(e2)
  end
end

Then /^I should (not )?see "(.*)" after "(.*)"$/ do |not_see, e1, e2|
  if not_see
    expect(page.body.index(e1)).to be < page.body.index(e2)
  else
    expect(page.body.index(e1)).to be > page.body.index(e2)
  end
end

Then /^The client_ssn of item "(.*)" should be "(.*)"$/ do |item_id, val|
  item_attr = Item.find_by(item_id).client_ssn
  expect(item_attr.to eq(val))
end


Then("I should match {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given /^PENDING/ do
  pending
end