class PaymentService
  def self.update_amount(event, amount)
    return false unless amount

    amount_paid = calculate_amount_paid(amount, event.reversion)
    
    event.update(
      amount: amount,
      amount_paid: amount_paid
    )
  end

  def self.mark_as_paid(event, payment_params)
    event.update(
      paid: true,
      payment_date: payment_params[:payment_date],
      payment_method: payment_params[:payment_method],
      payment_details: payment_params[:payment_details]
    )
  end

  def self.mark_as_unpaid(event)
    event.update(
      paid: false,
      payment_date: nil,
      payment_method: nil,
      payment_details: nil
    )
  end

  private

  def self.calculate_amount_paid(amount, reversion)
    return 0 unless amount && reversion
    (amount * reversion / 100).round(2)
  end
end