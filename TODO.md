# To Do List

List is in order of priority, with time estimates and the following tags.

* [BUGS] resolve unexpected site behavior
* [CALC] calculators
* [DATA] database and data storage
* [TEST] testing, QA
* [ALGO] algorithms, EHP, other backend
* [DVPS] devops and misc
* [FRNT] web development, frontend

## Backlog

* [DATA] Display players' ranks on F2P.wiki only (8h)
* [FRNT] FAQs page (8h)
* [ALGO] Fix time-to-max to include bonus xp (4h)
  * Reg ttm should be <2400h
* [BUGS] Fix cache issues where users must use private mode to use site (2h)
* [FRNT] Create new pages to compare gains and records (2h)
* [TEST] Create unit test suite (24h)
* [DVPS] Explore migrating away from Heroku (40h)
* [DATA] Explore options to improve datapoint storage (12h)
  * AWS EC2, DigitalOcean
* [DVPS] Allow upload of content (flairs, news, etc) (24h)
  * Create admin user(s)?
* [DATA] Add and display player created_at/updated_at timestamps (2h)
* [ALGO] Improve HC death, de-iron, and de-UIM detection (4h)
* [CALC] Fix ranged DPS calculator to use correct attack speed (30m)
* [CALC] Fix GP/XP calculator to update GE prices once per hour (2h)
* [CALC] Create general drop rate calculator (2h)
* [CALC] Create Ogress drops calculator (3h)
* [CALC] Create law usage calculator (3h)
* [ALGO] Create level 3 skiller EHP across Reg/IM/HC/UIM. (4h)
* [FRNT] Fix scrolls to not show small gaps (2h)
* [FRNT] Fix tables with long rows to not be cut off (1h)
* [FRNT] Fix names and flairs that spill to two lines long (1h)
* [FRNT] Consider restructuring Supporters list (2h)

## In Progress

* [DVPS] Complete open sourcing (8h)
  * refactoring to improve readability
    * move stuff out of config/initializers/assets.rb
    * separate out API/parsing from Player
    * separate out algorithms from Player
    * ~~remove deprecrated code from players_controller.rb~~
    * ~~do not allow player creation unless F2P~~
  * READMEs

## Done

* [DVPS] Upgrade to Rails 5.2 (4h)
  * remove unused gems
* [DATA] Remove deprecated columns from competitions (30m)
* [ALGO] Update Reg EHP from no-alt EHP to alt EHP. (2h)
* [ALGO] Update IM/HC/UIM EHP to use Ogress EHP. (40h)
* [ALGO] Implement Bonus XP algorithms (40h)
