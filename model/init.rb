# Here goes your database connection and options:

# Here go your requires for models:
# require 'model/user'
require 'sequel'
require 'sequel/extensions/migration'
require 'sequel/extensions/pagination'
Sequel::Model.plugin :validation_helpers
DB = Sequel.sqlite 'spox.db.sql3'
Sequel::Migrator.apply(DB, __DIR__ + '/migrations')
Sequel::Model.unrestrict_primary_key

Dir.new(File.dirname(__FILE__)).each{|f| require "model/#{f}" if f[-2,2] == 'rb'}