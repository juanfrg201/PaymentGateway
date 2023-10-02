class ChargesController < ApplicationController
  def new
    @charge = Charge.new
  end

  def create
    @charge = Charge.new(amount: create_params[:amount], user_id: current_user.id) 
    if @charge.save 
      data = {
        merchant_id: ENV['PAYU_MERCHANT_ID'],
        reference: @charge.uid,
        value: @charge.amount,
        currency: "COP"
      }
      @signature = signature(@charge)
      redirect_to payu_charges_path(id: @charge.id)
    else  
      render :new
    end
  end

  def payu 
    @charge = Charge.find(params[:id])
    @signature = signature(@charge)
  end

  private

  def create_params 
    params.permit(:amount)
  end

  def signature(charge)
    msg = "#{ENV['PAYU_API_KEY']}~#{ENV['PAYU_MERCHANT_ID']}~#{charge.uid}~#{charge.amount}~COP"
    Digest::MD5.hexdigest(msg)
  end
end
