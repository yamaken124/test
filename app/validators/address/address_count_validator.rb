class Address < ActiveRecord::Base
  class AddressCountValidator < ActiveModel::Validator

    def validate(record)
      if Address.where(user_id: record.user_id).length >= 3
        record.errors.add(:base, I18n.t("validate_registration.address"))
      end
    end

  end
end