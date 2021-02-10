class PlayerClanLink < ActiveRecord::Base
  belongs_to :player
  belongs_to :clan
end
