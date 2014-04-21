class UsersController < ApplicationController

  def index
    redirect_to new_user_path
  end

  def create
    @user = User.new params[:user]
    if @user.present?
      if get_reps @user.full_address
        @user.save
        if params[:commit] == "get representatives"
          @user.update_attributes :submit => "get representatives"
        end
      end
      login @user
      redirect_to user_path @user
    else
      redirect_to new_user_path
    end
  end

  def new
    if current_user
      @user = current_user
    else
      @user = User.new
    end
  end

  def show
    @user = current_user
    state = current_user.state
    city = current_user.city
    if current_user.submit == "get representatives"
      if get_reps current_user.full_address
        @reps = get_reps current_user.full_address
        @user.update_attributes :submit => "get representatives"
      else
        @reps = "sorry, that address didn't work. maybe there was a typo?"
      end
    else
      if get_candidates state, city
        @show = get_candidates state, city
        send_message @show
      else
        @show = "sorry, that address didn't work. maybe there was a typo?"
      end
    end
  end

  # def edit
  #   @user = current_user
  #   redirect_to new_user_path
  # end

  helper_method :current_user
  helper_method :login

end