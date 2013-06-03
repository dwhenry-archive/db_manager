module Builder
  def create_db_server(name)
    yield Builder::ServerSet.new(name)
  end

  def check_db_server(name)
    visit db_server_check_path(name)
    within('body') { return page.html }
  end

  def travel_to_monday
    Timecop.travel(Date.today - Date.today.wday + 1) do
      yield
    end
  end

  def travel_to_sunday
    Timecop.travel(Date.today - Date.today.wday ) do
      yield
    end
  end

  class ServerSet
    def initialize(name)
      @server = ::ServerSet.create(name: name, server_type: 'DbServer')
    end

    Date::DAYNAMES.each do |day_name|
      define_method :"enable_#{day_name.downcase}" do
        @server.settings.create(key: day_name.downcase, value: 'true')
      end
    end

    def enable_round_robin
      @server.settings.create(key: 'round_robin', value: 'true')
    end

    def set_last_run(date)
      Timecop.travel(date) do
        @server.logs.create(action: 'db_update_complete', source: 'test')
      end
    end
  end
end
