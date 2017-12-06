require 'whenever/capistrano'

set :whenever_environment, defer { stage }
set :whenever_command, 'bundle exec whenever'