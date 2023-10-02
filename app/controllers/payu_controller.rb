class PayuController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:confirmation]


  def response
    @charge = Charge.where(uid: params[:referenceCode]).take
    if @charge.nil?
      @error = "No se encontro el pago"
    else
      if params[:signature] != signature(@charge, params[:transactionState])
        @error = "La firma no existe"
      end
    end
  end

  def confirmation
    @charge = Charge.where(uid: params[:reference_sale]).take
    if @charge.nil?
      head :unprocessable_entity
      return
    end

    @charge.update!(response_data: params.as_json)

    if params[:sign] == signature(@charge, params[:state_pol])
      @charge.update_status(params[:state_pol])
      @charge.update_payment_method(params[:payment_method_type])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private 

  def signature(charge, state)
    msg = "#{ENV['PAYU_API_KEY']}~#{ENV['PAYU_MERCHANT_ID']}~#{charge.uid}~#{charge.amount}~COP~#{params[:state]}"
    Digest::MD5.hexdigest(msg)
  end

  
end
