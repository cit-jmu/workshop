class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_action :load_available_settings

  load_and_authorize_resource

  respond_to :html, :json

  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
    respond_with(@settings)
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
    respond_with(@setting)
  end

  # GET /settings/new
  def new
    @setting = Setting.new
    respond_with(@setting)
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)
    @setting.last_changed_by = current_user.username
    @setting.save
    respond_with(@setting)
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    updates = setting_params
    updates[:last_changed_by] = current_user.username
    @setting.update(updates)
    @setting.save
    respond_with(@setting)
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_with(@setting)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:name, :value)
    end

    def load_available_settings
      @available_settings = [
        ['Evaluation URL', 'evaluation_url']
      ]
    end
end
