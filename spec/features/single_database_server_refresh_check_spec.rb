require 'spec_helper'

feature %{
  When Querying by a specific database name
} do

  module Builder
    class Server
      def initialize(name)
        @server = ::Server.create(name: name, server_type: 'DbServer')
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

  def create_db_server(name)
    yield Builder::Server.new(name)
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

  scenario 'Return 404 when server is not configured' do
    expect do
      check_db_server('invalid_server')
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  scenario 'When server exists and is configured to run on the given day it will return true' do
    travel_to_sunday do
      create_db_server('test_server') { |s| s.enable_sunday }

      check_db_server('test_server').should == 'true'
    end
  end

  scenario 'When server exists and is configured not to run on the given day it will return false' do
    travel_to_sunday do
      create_db_server('test_server') { |s| s.enable_monday }

      check_db_server('test_server').should == 'false'
    end
  end

  context 'When multiple server are set to round robin mode' do
    scenario 'it will select the first server by id if no last update data' do
      travel_to_monday do
        create_db_server('test_server_1') do |s|
          s.enable_monday
          s.enable_round_robin
        end
        create_db_server('test_server_2') do |s|
          s.enable_monday
          s.enable_round_robin
        end

        check_db_server('test_server_1').should == 'true'
        check_db_server('test_server_2').should == 'false'
      end
    end

    scenario 'it will select the server with the oldest copy' do
      travel_to_monday do
        create_db_server('test_server_1') do |s|
          s.enable_monday
          s.enable_round_robin
          s.set_last_run(Date.today-1)
        end
        create_db_server('test_server_2') do |s|
          s.enable_monday
          s.enable_round_robin
          s.set_last_run(Date.today-2)
        end

        check_db_server('test_server_1').should == 'false'
        check_db_server('test_server_2').should == 'true'
      end
    end

    scenario 'it will select the server without an update if one exists' do
      travel_to_monday do
        create_db_server('test_server_1') do |s|
          s.enable_monday
          s.enable_round_robin
          s.set_last_run(Date.today-1)
        end
        create_db_server('test_server_2') do |s|
          s.enable_monday
          s.enable_round_robin
        end

        check_db_server('test_server_1').should == 'false'
        check_db_server('test_server_2').should == 'true'
      end
    end

    scenario 'it will ignore round robin which dont include the current day' do
      travel_to_monday do
        create_db_server('test_server_1') do |s|
          s.enable_monday
          s.enable_round_robin
          s.set_last_run(Date.today-1)
        end
        create_db_server('test_server_2') do |s|
          s.enable_sunday
          s.enable_round_robin
          s.set_last_run(Date.today-2)
        end

        check_db_server('test_server_1').should == 'true'
        check_db_server('test_server_2').should == 'false'
      end
    end
  end
end