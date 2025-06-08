class BarsController < ApplicationController
  before_action :set_bar, only: %i[ show edit update destroy ]

  # GET /bars
  def index
    @q = Bar.ransack(params[:q])
    @bars = @q.result.includes(:specialties)

    @bars = @bars.limit(12) if params[:q].blank?
  end

  # GET /bars/1
  def show
    @bar = Bar.find(params[:id])
  end

  # GET /bars/new
  def new
    @bar = Bar.new
  end

  # GET /bars/1/edit
  def edit
  end

  # POST /bars
  def create
    @bar = Bar.new(bar_params)

    if @bar.save
      redirect_to @bar, notice: "Bar was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bars/1
  def update
    if @bar.update(bar_params)
      redirect_to @bar, notice: "Bar was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bars/1
  def destroy
    @bar.destroy!
    redirect_to bars_url, notice: "Bar was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bar
      @bar = Bar.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bar_params
      params.require(:bar).permit(:name, :address, :price_range, :smoking_status, :description)
    end
end
