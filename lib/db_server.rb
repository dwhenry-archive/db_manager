class DbServer
  def initialize(name)
    @name = name
  end

  def status
    if server.setting('round_robin') == 'true'
      round_robin_servers.first == server ? 'true' : 'false'
    else
      server.setting(day_name) || 'false'
    end
  end

private

  def round_robin_servers
    Server
      .where(server_type: 'DbServer')
      .joins('join server_settings rr_settings on rr_settings.server_id = servers.id')
      .where(rr_settings: {key: 'round_robin', value: 'true'})
      .joins('join server_settings wd_settings on wd_settings.server_id = servers.id')
      .where(wd_settings: {key: Date::DAYNAMES[Date.today.wday].downcase, value: 'true'})
      .sort_by{|s| s.logs.last.try(:created_at) || Time.at(0) }
  end

  def server
    @server ||= Server.where(name: @name, server_type: 'DbServer').first || raise(ActiveRecord::RecordNotFound)
  end

  def day_name
    Date::DAYNAMES[Date.today.wday]
  end
end
