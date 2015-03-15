class Address < ActiveRecord::Base
  class AddressCountValidator < ActiveModel::Validator

    def validate(record)
      if record.reach_upper_limit?(record.user_id)
        record.errors.add(:base, I18n.t("validate_registration.address"))
      end
    end

  end
end