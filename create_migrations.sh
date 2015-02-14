rails g model address user:references last_name:string first_name:string address:string city:string zipcode:string phone:string alternative_phone:string
rails g model product name:string description:text is_valid_at:datetime is_invalid_at:datetime
rails g model variant sku:string product:references is_valid_at:datetime is_invalid_at:datetime
rails g model price variant:references amount:integer
rails g model tax_rate amount:decimal is_valid_at:datetime is_invalid_at:datetime 
rails g model purchase_order user:references state:integer
rails g model single_order purchase_order:references
rails g model single_order_detail single_order:references number:string item_total:integer total:integer completed_at:datetime address:references shipment_total:integer additional_tax_total:integer adjustment_total:integer item_count:integer date:date lock_version:integer
rails g model single_line_item variant:references single_order_detail:references quantity:integer price:integer tax_rate_id:integer additional_tax_total:integer
rails g model subscription_order purchase_order:references variant:references
rails g model subscription_term subscription_order:references term:integer interval:integer interval_unit:integer
rails g model subscription_order_detail subscription_order:references number:string item_total:integer total:integer completed_at:datetime address:references shipment_total:integer additional_tax_total:integer confirmation_delivered:boolean guest_token:string adjustment_total:integer item_count:integer date:date lock_version:integer
rails g model subscription_line_item variant:references subscription_order_detail:references quantity:integer price:integer tax_rate_id:integer additional_tax_total:integer
rails g model taxon parent_id:integer positon:integer name:string permalink:string taxonomy_id:integer description:text
rails g model taxonomy name:string position:integer
rails g model products_taxon product:references taxon_id:integer position:integer
rails g model bill address:references item_total:integer total:integer shipment_total:integer additional_tax_total:integer used_point:integer
rails g model bills_order_detail bill:references order_detail_id:integer order_detail_type:string
rails g model payment amount:integer used_point:integer payment_method_id:integer
rails g model payment_method name:string description:text environment:string is_valid_at:datetime is_invalid_at:datetime
rails g model bills_payment bill:references payment:references
