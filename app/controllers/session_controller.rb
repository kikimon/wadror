class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    #jos käyttäjää ei ole olemassa uudelleenohjataan takaisin, muutoin talletetaan kirjautuneen käyttäjän id sessioon ja uudelleenohjataan käyttäjän sivulle
    if user.nil?
        redirect_to :back, notice: "User #{params[:username]} does not exist!"
      else
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
      end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
