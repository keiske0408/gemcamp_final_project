class Admin::ItemsController < Admin::BaseController
  before_action :set_item, only: %i[show edit update destroy,:start, :pause, :end, :cancel]
  layout 'admin'

  def start
    if @item.start
      flash[:notice] = 'Item started successfully.'
    else
      flash[:alert] = 'Unable to start the item.'
    end
    redirect_to admin_items_path
  end

  def pause
    if @item.pause
      flash[:notice] = 'Item paused successfully.'
    else
      flash[:alert] = 'Unable to pause the item.'
    end
    redirect_to admin_items_path
  end

  def end
    if @item.end
      flash[:notice] = 'Item ended successfully.'
    else
      flash[:alert] = 'Unable to end the item.'
    end
    redirect_to admin_items_path
  end

  def cancel
    if @item.cancel
      flash[:notice] = 'Item cancelled successfully.'
    else
      flash[:alert] = 'Unable to cancel the item.'
    end
    redirect_to admin_items_path
  end

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    puts "Params: #{params[:item]}"
    @item = Item.new(item_params)
    puts "Image: #{@item.image}"
    # Set default batch_count if it's blank
    @item.batch_count ||= 0

    if @item.save
      puts "Image URL: #{@item.image.url}"
      redirect_to admin_items_path, notice: 'Item was successfully created.'
    else
      puts @item.errors.full_messages # Debug line
      render :new
    end
  end

  def edit
  end

  def update
    # Set default batch_count if it's blank
    item_params[:batch_count] ||= 0
    if @item.update(item_params)
      redirect_to admin_items_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    update(deleted_at: Time.current)
    redirect_to admin_items_path, notice: 'Item was successfully deleted.'
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :minimum_tickets, :batch_count, :online_at, :offline_at, :start_at, :status, :image, :state, :category_id)
  end
end
