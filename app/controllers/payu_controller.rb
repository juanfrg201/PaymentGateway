class PayuController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:confirmation]


  def response
    @charge = Charge.where(uid: params[:referenceCode]).take
    @error = nil
  end

  def confirmation
    @charge = Charge.where(uid: params[:reference_sale]).take
    if @charge.nil?
      head :unprocessable_entity
      return
    end

    @charge.update!(response_data: params.as_json)

    if params[:sign] == signature(@charge, params[:state_pol], params[:reference_sale], params[:currency])
      @charge.update_status(params[:state_pol])
      @charge.update_payment_method(params[:payment_method_type])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private 

  def signature(charge, state, reference, currency)
    new_value = sprintf("%.1f", BigDecimal(charge.amount))
    msg = "#{ENV['PAYU_API_KEY']}~#{ENV['PAYU_MERCHANT_ID']}~#{reference}~#{new_value}~#{currency}"
    puts msg
    msg += "~#{state}" if state
    Digest::MD5.hexdigest(msg)
  end

  
end
