class Log < ActiveRecord::Base
  belongs_to :server
  attr_accessible :action, :source
end
