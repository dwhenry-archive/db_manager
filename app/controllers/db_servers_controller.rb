class DbServersController < ApplicationController
  # GET /db_servers
  # GET /db_servers.json
  def index
    @db_servers = DbServer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @db_servers }
    end
  end

  # GET /db_servers/1
  # GET /db_servers/1.json
  def show
    @db_server = DbServer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @db_server }
    end
  end

  # GET /db_servers/new
  # GET /db_servers/new.json
  def new
    @db_server = DbServer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @db_server }
    end
  end

  # GET /db_servers/1/edit
  def edit
    @db_server = DbServer.find(params[:id])
  end

  # POST /db_servers
  # POST /db_servers.json
  def create
    @db_server = DbServer.new(params[:db_server])

    respond_to do |format|
      if @db_server.save
        format.html { redirect_to @db_server, notice: 'Db server was successfully created.' }
        format.json { render json: @db_server, status: :created, location: @db_server }
      else
        format.html { render action: "new" }
        format.json { render json: @db_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /db_servers/1
  # PUT /db_servers/1.json
  def update
    @db_server = DbServer.find(params[:id])

    respond_to do |format|
      if @db_server.update_attributes(params[:db_server])
        format.html { redirect_to @db_server, notice: 'Db server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @db_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /db_servers/1
  # DELETE /db_servers/1.json
  def destroy
    @db_server = DbServer.find(params[:id])
    @db_server.destroy

    respond_to do |format|
      format.html { redirect_to db_servers_url }
      format.json { head :no_content }
    end
  end
end
