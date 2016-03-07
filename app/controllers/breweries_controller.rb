class BreweriesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show, :nglist]
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  #before_filter :authenticate, only: [:destroy]
  before_action :skip_if_cached, only:[:index]


  def skip_if_cached
    @order = params[:order] || 'name'
    return render :index if fragment_exist?( "brewerylist-#{@order}"  )
  end

  # GET /breweries
  # GET /breweries.json
  def index
    #@breweries = Brewery.all
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired

    #commented out for caching, otherwise cache should remember this order too
    #set_session_order
 
    @active_breweries = order_breweries(@active_breweries)
    @retired_breweries = order_breweries(@retired_breweries)
  end

  def nglist
  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    expire_fragment('brewerylist')
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  #change the activity status of a brewery, active <-> retired
  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end


  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    expire_fragment('brewerylist')
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    expire_fragment('brewerylist')
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

   def set_session_order

      case session[:order]
      when nil then session[:order] = "asc"
      when "asc" then session[:order] = "desc"
      when "desc" then session[:order] = "asc"	
      end

   end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def order_breweries(type)

      case @order
      when 'name'
        #if  session[:order] == "asc"
           type.sort_by{ |b| b.name}
        #else type.sort_by{ |b| b.name}.reverse
        #end
      when 'year' 
        #if session[:order] == "asc"
           type.sort_by{ |b| b.year}
        #else type.sort_by{ |b| b.year}.reverse
        #end
      end
    end

   private

   #def authenticate
   #   admin_accounts = { "admin" => "secret", "pomo" => "bossi", "tonttu" => "lahja", "n00b" => "green"}
   #   authenticate_or_request_with_http_basic do |username, password|
   #   	 admin_accounts.has_key?(username) and admin_accounts.key(password) == username
   #   end
   #end
end
