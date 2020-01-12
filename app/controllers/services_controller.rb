# frozen_string_literal: true

class ServicesController < ApplicationController
  before_action :load_service, only: %i(edit update destroy)

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to root_path, notice: "新しいサービスを登録しました。"
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
        :notified_on)
    end

    def load_service
      @service = Service.find(params[:id])
    end
end
