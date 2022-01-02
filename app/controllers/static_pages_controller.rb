class StaticPagesController < ApplicationController
  def home
    @categories = Category.all
  end

  def help
  end

  def about
  end

  def category
    catName = params[:title]
    @items = Item.where("category like ? ", catName)
  end
end


