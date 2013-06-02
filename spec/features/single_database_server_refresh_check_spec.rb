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
    end
  end

  def create_db_server(name)
    yield Builder::Server.new(name)
  end

  def check_db_server(name)
    visit db_server_check_path(name)
    within('body') { return page.html }
  end

  scenario 'Return 404 when server is not configured' do
    expect do
      check_db_server('invalid_server')
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  scenario 'When server exists and is configured to run on the given day it will return true' do
    Timecop.travel(Date.today - Date.today.wday) do
      create_db_server('test_server') { |s| s.enable_sunday }

      check_db_server('test_server').should == 'true'
    end
  end

  scenario 'When server exists and is configured not to run on the given day it will return false' do
    Timecop.travel(Date.today - Date.today.wday) do
      create_db_server('test_server') { |s| s.enable_monday }

      check_db_server('test_server').should == 'false'
    end
  end

  scenario 'When multiple server are set to round robin mode it will select the first server by id' do
    Timecop.travel(Date.today - Date.today.wday) do
      create_db_server('test_server_1') { |s| s.enable_monday; s.enable_round_robin }
      create_db_server('test_server_2') { |s| s.enable_monday; s.enable_round_robin }

      check_db_server('test_server_1').should == 'true'
      check_db_server('test_server_2').should == 'false'
    end

  end
end