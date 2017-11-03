class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    
    sort_by = params[:sort_by] || session[:sort_by]
    search_term = params[:search] || session[:search]
    if params[:sort_by] != session[:sort_by] || params[:search] != session[:search]
      session[:sort_by] = sort_by
      session[:search] = search_term
      redirect_to items_path(:sort_by => sort_by, :search => search_term) and return
    end
    
    case sort_by
    when 'client_ssn'
      ordering = 'client_ssn'
    when 'client_name'
      ordering = 'client_name'
    end
    
    
    if search_term != nil
      if search_term.count("0-9") > 0
        search_term = search_term.tr('-', '')
        search_term = search_term.tr(' ', '')
      end
      @items = Item.where("client_name like ? OR client_ssn like ?", "%#{search_term}%", "%#{search_term}%")
      @old_items = Item.where("(client_name like ? OR client_ssn like ?) AND date_opened < ?", "%#{search_term}%", "%#{search_term}%", 90.days.ago)
    else
      @items = Item.order(ordering)
      @old_items = Item.where("date_opened < ?", 90.days.ago)
    end  
    
    @items_alert_message = ""
    if @old_items.length > 0
      @items_alert_message = "Case has been open for 90 days: "
      @old_items.each do |item|
        @items_alert_message += item[:client_ssn] + ", "
      end
    end
    
    
    
end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find params[:id]
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.create!(item_params)
    flash[:notice] = 'Item was successfully created.' 
    redirect_to items_path
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to items_path, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
       format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    # @item.destroy
    # respond_to do |format|
    #   format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:client_ssn, :client_name, :date_opened, :date_closed)
   end
end
