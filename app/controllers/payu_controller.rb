class PayuController < ApplicationController
  skip_before_action :verify_authenticy_token, only: [:confirmation]

  def confirmation
    @charge = Charge.find_by(uid: params[:reference_sale])
    if @charge.nil?
      head :unprocessable_entity
      return
    end
    if params[:sign] == signature(@charge, params[:state_pol])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def response
    @charge = Charge.find_by(uid: params[:referenceCode])
    if @charge.nil?
      @error = "No se encontro el pago"

    else
      if params[:signature] != signature(@charge)
        @error = "La firma no existe"
      end
    end
  end

  private 

  def signature(charge, state)
    msg = "#{ENV['PAYU_API_KEY']}~#{ENV['PAYU_MERCHANT_ID']}~#{charge.uid}~#{charge.amount}~COP~#{params[:state]}"
    Digest::MD5.hexdigest(msg)
  end
end
