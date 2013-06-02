class Server < ActiveRecord::Base
  attr_accessible :name, :server_type

  has_many :settings, class_name: 'ServerSettings'
  has_many :logs

  def setting(key)
    key = key.downcase
    settings.each do |setting|
      return setting.value if setting.key == key
    end
    nil
  end
end
