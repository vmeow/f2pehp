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

Then /^The client_ssn of item "(.*)" should be "(.*)"$/ do |item_id, val|
  item_attr = Item.find_by(item_id).client_ssn
  expect(item_attr.to eq(val))
end