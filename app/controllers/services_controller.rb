# frozen_string_literal: true

class ServicesController < ApplicationController
  before_action :load_service, only: %i(edit update destroy)

  def new
    @service = current_user.services.build
  end

  def create
    @service = current_user.services.build(service_params)
    if @service.save
      redirect_to root_path, notice: "サービスを登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to root_path, notice: "サービスを修正しました。"
    end
  end

  def destroy
    if @service.destroy
      redirect_to root_path, notice: "サービスを削除しました。"
    end
  end

  private
    def service_params
      params.require(:service).permit(
        :name,
        :description,
        :plan,
        :price,
        :renewed_on,
        :remind_on)
    end

    def load_service
      @service = current_user.services.find(params[:id])
    end
end
