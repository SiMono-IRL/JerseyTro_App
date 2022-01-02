class Order < ApplicationRecord
  belongs_to :user
  attr_accessor :stripe_token
  def order_params
    params.require(:order).permit( :order_date, :user_id, :status)
end


has_many :orderitems
belongs_to :user

def submit!(total)
  if !create_stripe_charge(total)
    return [false, 'There was an error charging your credit card.']
  end

  self.save

  return [true]
end

def create_stripe_charge(total)
  charge = Stripe::Charge.create(
    amount: total,
    currency: 'eur',
    description: "Jerseytro Order ##{id}",
    source: stripe_token,
    source: 'tok_visa'
  )
  self.stripe_charge_id = charge.id
    rescue Stripe::StripeError => e
  false
end


end
