namespace :insert_stock_quantity do
  desc "insert stock quantity for all variants"
  task :execute_insertion => :environment do
    Variant.update_all(stock_quantity: 10)
  end
end
