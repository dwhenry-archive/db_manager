class UpdateDbsController < ApplicationController
  def check
    server = Server.where(name: params['name'], server_type: 'DbServer').first || raise(ActiveRecord::RecordNotFound)
    day_name = Date::DAYNAMES[Date.today.wday]
    render text: server.setting(day_name) || 'false'
  end
end