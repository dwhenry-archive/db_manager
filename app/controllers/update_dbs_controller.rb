class UpdateDbsController < ApplicationController
  def check
    server = DbServer.new(params['name'])

    render text: server.status
  end
end
