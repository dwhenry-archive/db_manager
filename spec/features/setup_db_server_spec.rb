require 'spec_helper'

feature %{
  Setup and Manage DB Server via webpage
} do
  context 'Can create a new db server set' do
    scenario 'Enabled for Monday without round robin' do
      visit new_db_server_path

      fill_in 'Name', with: 'Test Server'
      check 'Mon'
      click_on 'Save'

      server = DbServer.new('Test Server')
      server.setting('round_robin').should eq 'true'
      server.setting('monday').should eq 'true'

      (Date::DAY_NAMES - 'Monday').each do |day_name|
        server.setting(day_name).should eq 'false'
      end
    end

    scenario 'Enabled for Monday with round robin'
    scenario 'Enabled for All weekdays without round robin'
    scenario 'Enabled for All weekdays with round robin'
  end
end

