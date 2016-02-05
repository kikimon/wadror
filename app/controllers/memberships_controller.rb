class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :destroy]

  # GET /memberships
  # GET /memberships.json
  # def index
  #haetaan kirjautuneen käyttäjän jäsenyydet
  # @memberships = Membership.find_by(user_id = current_user)
  # end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  #def edit
  #end

  # POST /memberships
  # POST /memberships.json
  def create
    #@membership = Membership.create params.require(:membership).permit(:beer_club_id)
    @membership = Membership.new(membership_params)
    current_user.memberships << @membership
   
    respond_to do |format|
      if @membership.save              
        format.html { redirect_to :root, notice: 'Membership was successfully created.' }
        format.json { render :show, status: :created, location: show_beer_club_path(@membership.beer_club_id)}
      else
        @beer_clubs = BeerClub.all
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  #def update
  #  respond_to do |format|
  #    if @membership.update(membership_params)
  #      format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @membership }
  #    else
  #      format.html { render :edit }
  #      format.json { render json: @membership.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy if current_user == @membership.user
    respond_to do |format|
      format.html { redirect_to :root, notice: 'Membership was successfully removed' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id)
    end
end
