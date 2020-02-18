namespace :runs do
  desc "Reset runs table"
  task :reset => :environment do
    q = '''
UPDATE runs
SET hour = CURRENT_TIMESTAMP,
    failed_updates = 0
;
'''
    ActiveRecord::Base.connection.execute(q)
  end
end
