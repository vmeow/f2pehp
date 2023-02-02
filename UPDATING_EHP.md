# Code

All EHP related data changes can be made in `config/initializers/assets.rb`.

Here is an example of what code you would need to change for the attack skill for a regular account.

```ruby
config.ehp_reg['attack_method']
config.ehp_reg['attack_method_video']
config.ehp_reg['attack_tiers']
config.ehp_reg['attack_xphrs']
```

Then, if there is any bonus experience assosicated with the attack skill, you would set that also.

```ruby
config.bonus_xp_reg[[ratio, bonus_for, bonus_from, start_xp, end_xp]]
```

# Deployment

Create a pull request to Master from a fork. If needed, can deploy branch to f2pehp2 https://f2pehp2.herokuapp.com/ currently not in service.

When the code looks ready to deploy, merge into master, log into Heroku and perform the queries listed below.

## Queries

Run this query in the heroku console. (Heroku run `console`)

```ruby
Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch| batch.each do |player| begin player.recalculate_ehp player.recalculate_current_ehp rescue next end end end
```
