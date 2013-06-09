class DbServer
  class << self
    delegate :all,
      to: ServerSet::DbServerSet
  end

  attr_reader :name

  def initialize(name=nil)
    @name = name
  end

  def status
    if server.setting('round_robin') == 'true'
      round_robin_servers.first == server ? 'true' : 'false'
    else
      server.setting(day_name) || 'false'
    end
  end

  def server
    @server ||= if name
      ServerSet::DbServerSet.where(name: name).first || raise(ActiveRecord::RecordNotFound)
    else
      ServerSet.new(server_type: 'DBServerSet')
    end
  end

private

  def round_robin_servers
    ServerSet::DbServerSet.round_robin.for_today
      .sort_by do |server|
        (server.logs.last.try(:created_at) || Time.at(0)).to_date
      end
  end

  def day_name
    Date::DAYNAMES[Date.today.wday]
  end
end
