# frozen_string_literal: true

class HomeViewersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_home, only: %i[create index new destroy]

  def index
    authorize @home, :edit?
    @viewers = policy_scope(HomeViewer)
               .includes(:user)
               .where(home_id: params[:home_id])
               .page(params[:page])
    @invitations = @home.invitations.pending
  end

  def new
    authorize @home, :edit?
    @new_viewer = Invitation.new
  end

  def destroy
    authorize @home, :edit?
    viewer = @home.home_viewers.find_by!(user_id: params[:id])
    viewer.destroy
  ensure
    redirect_to home_home_viewers_path(@home)
  end

  private

  def set_home
    @home = policy_scope(Home).find(params[:home_id])
  end

  def invite_user; end

  def viewer_params
    params[:viewer].permit(permitted_params)
  end

  def permitted_params
    %i[
      id
      email
      home_id
    ]
  end
end
