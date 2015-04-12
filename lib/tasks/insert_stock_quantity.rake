namespace :insert_stock_quantity do
  desc "insert stock quantity for all variants"
  task :execute_insertion => :environment do
    begin
      Variant.all.each do |variant|
        variant.update!(stock_quantity: 10)
      end
      puts "success!"
    rescue => e
      p e
    end
  end
end
