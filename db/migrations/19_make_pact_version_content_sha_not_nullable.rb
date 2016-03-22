require 'digest/sha1'
require_relative 'migration_helper'

Sequel.migration do
  change do
    puts '...'
  end
end
