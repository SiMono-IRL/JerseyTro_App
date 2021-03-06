class CartController < ApplicationController
  before_action :authenticate_user!
  def add
    # get product ID
id = params[:id]

   # if the cart is already created, use existing cart, else create a blank cart
if session[:cart] then
    cart = session[:cart]
else
  session[:cart] = {}
  cart = session[:cart]
end

  #if the product is already added, increments by 1, else set product to 1
if cart[id] then
  cart[id] = cart[id] + 1
else
  cart[id]= 1
end
  redirect_to :action => :index
end

def clearCart
    #sets session variable to nil and bring back to index
session[:cart] = nil
redirect_to :action => :index
end

def index
    # display cart
if session[:cart] then
      @cart = session[:cart]
else
      @cart = {}
end
end 

# Delete Item method
def remove
id = params[:id]
cart = session[:cart]
cart.delete id

redirect_to :root
end

def increase
    
  id = params[:id]
  cart = session[:cart]
  # Add one
  cart[id] = cart[id] + 1
  #Taking us to cart index[view] page
  redirect_to :action => :index
end

def decrease

  id = params[:id]
  cart = session[:cart]
  if cart[id] == 1 then
  cart.delete id
  else
  cart[id] = cart[id] - 1
  end
       #to cart index[view] page
  redirect_to :action => :index
  
  end

  def createOrder
    # Step 1: Get the current user
    @user = User.find(current_user.id)
   
    # Step 2: Create a new order and associate it with the current user
    @order = @user.orders.build(:order_date => DateTime.now, :status => 'Pending')
    @order.save
   
    # Step 3: For each item in the cart, create a new item on the order!!
    @cart = session[:cart] || {} # Get the content of the Cart
    @cart.each do | id, quantity |
    item = Item.find_by_id(id)
    @orderitem = @order.orderitems.build(:item_id => item.id, :title => item.title, :description => item.description, :quantity => quantity, :price=> item.price)
    @orderitem.save
    end

    @orders = Order.last

    @orderitems = Orderitem.where(order_id: Order.last)

    #session[:cart] = nil

   end

   def payment
      @order = Order.find_by_id(params["order_id"].to_i)
      @order.stripe_token = params["token"]
      @order.update_attributes(:name=>params["name"],:address=>params["address"],:city=>params["city"],:zip=>params["zip"])
      success, order_error_message = @order.submit!(params["total"].to_i)
      if success
        session[:cart] = nil
      else
        flash[:order_error_message] = order_error_message
        redirect_to checkout_path
      end
   end
   
end
   
