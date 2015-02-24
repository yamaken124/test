class PurchaseOrder < ActiveRecord::Base
  module Point
    def self.included(klass)
      klass.class_eval do
        def valid_point?(point)
          (point <= user.points) && point >= 0
        end
      end
    end
  end
end
