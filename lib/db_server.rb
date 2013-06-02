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
      .joins(:settings)
      .where(server_settings: {key: 'round_robin', value: 'true'})
  end

  def server
    @server ||= Server.where(name: @name, server_type: 'DbServer').first || raise(ActiveRecord::RecordNotFound)
  end

  def day_name
    Date::DAYNAMES[Date.today.wday]
  end
end
