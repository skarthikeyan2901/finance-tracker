class FriendshipsController < ApplicationController
  def create
    if User.where(id: params[:friend]).blank?
      flash[:alert] = "No such user!"
      redirect_to my_friends_path and return
    end
    # binding.break
    if current_user.friendships.where(friend_id: params[:friend]).present?
      flash[:alert] = "Already following this user!"
      redirect_to my_friends_path and return
    end
    current_user.friendships.build(friend_id: params[:friend])
    if current_user.save
      flash[:notice] = "Following friend!"
    else
      flash[:alert] = "There was something wrong while following friend!"
    end
    redirect_to my_friends_path
  end

  def destroy
    # binding.break
    if User.where(id: params[:id]).blank?
      flash[:alert] = "No such user!"
      redirect_to my_friends_path and return
    end
    if current_user.friendships.where(friend_id: params[:id]).blank?
      flash[:alert] = "You were not following the user in the first place to stop following them!"
      redirect_to my_friends_path and return
    end
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "Stopped following!"
    redirect_to my_friends_path
  end
end
