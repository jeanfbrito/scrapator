class ScrapesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_scrape, only: [:show, :edit, :update, :destroy]

  # GET /scrapes
  # GET /scrapes.json
  def index
    @scrapes = current_user.scrapes.all
    @jobs = Delayed::Job.all
  end

  # GET /scrapes/1
  # GET /scrapes/1.json
  def show
  end

  # GET /scrapes/new
  def new
    @scrape = Scrape.new
  end

  # GET /scrapes/1/edit
  def edit
  end

  def scrape
    ScrapeData.new.delay.perform(params[:id])
    redirect_to scrapes_path

  end

  # POST /scrapes
  # POST /scrapes.json
  def create
    @scrape = Scrape.new(scrape_params)
    @scrape.user = current_user

    respond_to do |format|
      if @scrape.save
        ScrapeData.new.delay.perform(@scrape.id)
        format.html { redirect_to @scrape, notice: 'Scrape was successfully created.' }
        format.json { render :show, status: :created, location: @scrape }
      else
        format.html { render :new }
        format.json { render json: @scrape.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scrapes/1
  # PATCH/PUT /scrapes/1.json
  def update
    respond_to do |format|
      if @scrape.update(scrape_params)
        ScrapeData.new.delay.perform(@scrape.id)
        format.html { redirect_to @scrape, notice: 'Scrape was successfully updated.' }
        format.json { render :show, status: :ok, location: @scrape }
      else
        format.html { render :edit }
        format.json { render json: @scrape.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scrapes/1
  # DELETE /scrapes/1.json
  def destroy
    @scrape.destroy
    respond_to do |format|
      format.html { redirect_to scrapes_url, notice: 'Scrape was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scrape
      @scrape = Scrape.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scrape_params
      params.require(:scrape).permit(:name, :user, :url, :xpath, :screenshot,
        :config_value, :read_value, :status, :last_read,
        scrape_steps_attributes: [:title, :xpath, :option, :value, :_destroy]
      )
    end
end
