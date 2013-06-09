class ServerSettings < ActiveRecord::Base
  belongs_to :server
  attr_accessible :key, :value
end
