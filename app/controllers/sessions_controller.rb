class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      check_active user
    else
      flash.now[:danger] = t "invalid_email_pass"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def check_remember user
    log_in user
    params[:session][:remember_me] == Settings.check_remember ? remember(user) : forget(user)
    redirect_back_or user
  end

  def check_active user
    if user.activated?
      check_remember user
    else
      message = t "account_not"
      message += t "check_mail"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
