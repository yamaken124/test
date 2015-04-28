namespace :insert_upper_used_point_limit do
  desc "insert_upper_used_point_limit"
  task :execute_insertion => :environment do
    Variant.all.each do |variant|
      UpperUsedPointLimit.where(variant_id: variant.id).first_or_create(limit: variant.price.try(:amount))
    end
  end
end
