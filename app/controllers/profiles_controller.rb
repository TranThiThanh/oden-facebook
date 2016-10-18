class ProfilesController < ApplicationController

  def update
    @user = current_user
    @profile = current_user.profile
    if @profile.update(profile_params)
      flash[:success] = "Profile Update!"
      redirect_to @user
    else
      flash[:danger] = "Something went wrong!"
      redirect_to @user
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:picture)
    end
end
