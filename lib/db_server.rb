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
    ServerSet::DbServerSet.round_robin.for_today
      .sort_by do |server|
        (server.logs.last.try(:created_at) || Time.at(0)).to_date
      end
  end

  def server
    @server ||= ServerSet::DbServerSet.where(name: @name).first || raise(ActiveRecord::RecordNotFound)
  end

  def day_name
    Date::DAYNAMES[Date.today.wday]
  end
end
