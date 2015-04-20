namespace :insert_temp_data_to_shipment do
  desc "insert temp data to shipment"
  task :execute_insertion => :environment do
    Shipment.all.each do |shipment|
      shipment.update(single_line_item_id: 1)
    end
  end
end
