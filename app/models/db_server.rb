class DbServer < ActiveRecord::Base
  attr_accessible :fri, :mon, :name, :sat, :state, :sun, :thu, :tue, :wed
end
