# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_home, only: %i[show edit destroy update]
  respond_to :html

  def index
    authorize :home
    @homes = policy_scope(Home)
             .includes(:home_type, :owner)
             .order(:name)
             .paginate(page: params[:page])
    respond_with(@homes)
  end

  def show
    parse_dates
    @keys = %w[temperature humidity]
    respond_with(@home)
  end

  def new
    authorize :home
    @home = Home.new
    respond_with(@home)
  end

  # rubocop:disable Metrics/AbcSize
  def create
    suburb = find_or_create_suburb home_params['home_suburb_name']

    params[:home].delete :home_suburb_name

    @home = Home.new(home_params.merge(owner_id: current_user.id, suburb_id: suburb&.id))

    authorize @home
    @home.save

    respond_with(@home)
  end
  # rubocop:enable Metrics/AbcSize

  def edit
    @home_types = HomeType.all
    @home_suburb_name = @home.suburb.name if @home.suburb

    respond_with(@home)
  end

  def update
    suburb = find_or_create_suburb home_params['home_suburb_name']

    params[:home].delete :home_suburb_name

    @home.update(home_params.merge(suburb_id: suburb ? suburb.id : nil))
    @home.save!
    respond_with(@home)
  end

  def destroy
    @home.destroy
    respond_with(@home)
  end

  private

  def parse_dates
    @day = params[:day]
    @day = Time.zone.today if @day.blank?
  end

  def home_params
    params[:home].permit(permitted_home_params)
  end

  def permitted_home_params
    %i[
      name
      home_suburb_name
      suburb_id
      is_public
      home_type_id
    ]
  end

  def set_rooms
    @rooms = policy_scope(Room).where(home_id: @home.id).limit(10)
  end

  def set_home
    @home = policy_scope(Home).includes(:rooms).includes(:sensors).find(params[:id])
    authorize @home
  end

  def find_or_create_suburb(name)
    suburb = nil

    if name.present?
      suburb = Suburb.find_by(name: name)
      suburb = Suburb.create!(name: name) unless suburb
    end

    suburb
  end
end
