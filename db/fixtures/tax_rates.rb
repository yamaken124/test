[
  { id: 1, amount: 0.08, is_valid_at: Time.new(2014, 4, 1, 0, 0, 0), is_invalid_at: Time.local(2099, 12, 31, 23, 59, 59) },
].each { |s| TaxRate.seed(s) }
