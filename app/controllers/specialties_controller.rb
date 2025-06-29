class SpecialtiesController < ApplicationController
  before_action :set_specialty, only: %i[ show edit update destroy ]

  # GET /specialties
  def index
    @specialties = Specialty.all
  end

  # GET /specialties/1
  def show
  end

  # GET /specialties/new
  def new
    @specialty = Specialty.new
  end

  # GET /specialties/1/edit
  def edit
  end

  # POST /specialties
  def create
    @specialty = Specialty.new(specialty_params)

    if @specialty.save
      redirect_to @specialty, notice: "Specialty was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /specialties/1
  def update
    if @specialty.update(specialty_params)
      redirect_to @specialty, notice: "Specialty was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /specialties/1
  def destroy
    @specialty.destroy!
    redirect_to specialties_url, notice: "Specialty was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specialty
      @specialty = Specialty.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def specialty_params
      params.require(:specialty).permit(:bar_id, :category, :is_main, :description)
    end
end
