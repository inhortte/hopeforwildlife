require 'dm-core'
require 'dm-migrations'

class EditMap
  include DataMapper::Resource

  property :id, Serial
  property :page, String, :length => 255, :required => true
  property :paragraph, Integer

  has n, :edits
end

class Edit
  include DataMapper::Resource

  property :id, Serial
  property :text, Text
  property :druh, String, :length => 10, :required => true, :default => 'HTML'
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :edit_map
end
