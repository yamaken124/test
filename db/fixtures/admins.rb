[{
  id: 1,
  email: 'info@finc.co.jp',
  password: 'D7nomTrZ1i',
  password_confirmation: 'D7nomTrZ1i',
},{
  id: 2,
  email: 'storeoperator@finc.co.jp',
  password: '1oKQBHekuK',
  password_confirmation: '1oKQBHekuK',
}
].each { |s| Admin.seed(s) }
