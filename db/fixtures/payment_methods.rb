[
  { id: 1, name: 'GmoPaymentGateway::CreditCard', description: 'Pay by gmo payment gateway development', environment: '', is_valid_at: Time.new(2015, 1, 1, 0, 0, 0), is_invalid_at: Time.local(2099, 12, 31, 23, 59, 59) },
  { id: 2, name: 'GmoPaymentGateway::PostPayment', description: 'Pay by gmo payment gateway development', environment: '', is_valid_at: Time.new(2015, 1, 1, 0, 0, 0), is_invalid_at: Time.local(2099, 12, 31, 23, 59, 59) },
].each { |s| PaymentMethod.seed(s) }
