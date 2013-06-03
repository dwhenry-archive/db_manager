class ServerSet
  class DbServerSet < ServerSet
    default_scope where(server_type: 'DbServer')
    # self.table_name = 'servers'

    scope :round_robin,
      joins('join server_settings rr_settings on rr_settings.server_set_id = server_sets.id')
        .where(rr_settings: {key: 'round_robin', value: 'true'})

    scope :for_today,
      joins('join server_settings wd_settings on wd_settings.server_set_id = server_sets.id')
        .where(wd_settings: {key: Date::DAYNAMES[Date.today.wday].downcase, value: 'true'})
  end
end