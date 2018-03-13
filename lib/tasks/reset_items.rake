desc "Reset items table"
task :reset_items => :environment do
     ActiveRecord::Base.connection.reset_pk_sequence!("Items")
end