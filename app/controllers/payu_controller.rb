class PayuController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:confirmation]

  def confirmation
    charge = Charge.where(uid: params[:reference_sale]).take
    if charge.nil?
      head :unprocessable_entity
      return
    end

    charge.update!(response_data: params.as_json)

    data = {
      merchant_id: params[:merchant_id],
      reference: params[:reference_sale],
      value: params[:value],
      currency: params[:currency],
      state: params[:state_pol]
    }
    if signature(data) == params[:sign]
      update_status(charge, params[:state_pol])
      update_payment_method(charge, params[:payment_method_type])
      head :ok
    else
      charge.error!
      head :unprocessable_entity
    end
  end

  def response
    @charge = Charge.find_by(uid: params[:referenceCode])

    data = {
      merchant_id: params[:merchantId],
      reference: params[:referenceCode],
      value: params[:TX_VALUE],
      currency: params[:currency],
      state: params[:transactionState]
    }
    if signature(data) == params[:signature]
      @charge.status = :pending
    else
      @charge.status = :error
      @charge.error_message = "La firma en la respuesta no es válida."
    end
  end

  private 

  def signature(data)
    new_value = sprintf("%.1f", BigDecimal(data[:value]))
    msg = "#{ENV['PAYU_API_KEY']}~#{data[:merchant_id]}~#{data[:reference]}~#{new_value}~#{data[:currency]}"
    msg += "~#{data[:state]}" if data[:state]
    Digest::MD5.hexdigest(msg)
  end

  def update_status(charge, status)
    if status == "4"
      charge.paid!
    elsif status == "7"
      charge.pending!
    elsif status == "6"
      charge.rejected!
      charge.update(error_message: params[:response_message_pol])
    end
  end

  def update_payment_method(charge, payment_method)
    if payment_method == "2"
      charge.credit_card!
    elsif payment_method == "4"
      charge.pse!
    elsif payment_method == "6"
      charge.debit_card!
    elsif payment_method == "7"
      charge.cash!
    elsif payment_method == "8" || payment_method == "10"
      charge.referenced!
    elsif payment_method == "14"
      charge.transfer!
    end
  end
end
