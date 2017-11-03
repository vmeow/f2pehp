# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Item.create([
              { client_name: 'John Doe', client_ssn: '111111111' },
              { client_name: 'Sally Sue', client_ssn: '222222222' },
              { client_name: 'Billy Bob', client_ssn: '333333333' },
              { client_name: 'Ender Wiggin', client_ssn: '000000000' }
            ])
