class UserMailer < ApplicationMailer
  default from: Settings.mailer.try(:user_mailer).try(:from),
    bcc: Settings.mailer.try(:user_mailer).try(:bcc)
  add_template_helper(ApplicationHelper)
  before_filter :user_mailer_smtp_settings
  after_filter :send_mail

  include ApplicationHelper

  def send_order_accepted_notification(order)
    sleep 1

    user_id = order.user_id
    @profile = Profile.find_by(user_id: user_id)
    @payment = order.single_order_detail.payment
    @detail = order.single_order_detail
    @address = @detail.address

    @subject = '【FiNCストア】ご購入ありがとうございます '
    @to = order.user.email
  end

  def send_item_canceled_notification(item)
    sleep 1

    @item = item
    @payment = item.single_order_detail.payment

    @subject = '【FiNCストア】注文キャンセルを承りました'
    @to = @payment.user.email
  end

  def send_one_click_item_canceled_notification(item)
    sleep 1

    @item = item
    @payment = item.one_click_detail.one_click_payment

    @subject = '【FiNCストア】注文キャンセルを承りました'
    @to = @payment.user.email
  end

  def send_items_shipped_notification(shipments, payment)
    sleep 1

    @payment = payment
    @detail = @payment.single_order_detail
    @address = @payment.address
    @carrier = '日本郵便株式会社' #TODO will change
    @shipments = shipments

    @subject = '【FiNCストア】発送が完了しました'
    @to = @payment.user.email
  end

  def send_return_request_accepted_notification(item)
    sleep 1

    @item = item
    @payment = @item.single_order_detail.payment
    @profile = Profile.find_by(user_id: @payment.user_id)
    @variant = Variant.find_by(id: @item.variant_id)
    @returned_item = ReturnedItem.find_by(single_line_item_id: @item.id, user_id: @payment.user_id)

    @subject = '【FiNCストア】返品リクエストを承りました'
    @to = @payment.user.email
  end


  private

    def user_mailer_smtp_settings
      ActionMailer::Base.smtp_settings = {
        :address => "smtp.gmail.com",
        :port => 587,
        :domain => 'finc.co.jp',
        :user_name => Settings.mailer.user_mailer.user_name,
        :password => Settings.mailer.user_mailer.password,
        :authentication => 'plain',
        :enable_starttls_auto => true,
      }
    end

    def send_mail
      if Rails.env.production?
        mail to: @to, subject: @subject
      else
        mail to: Settings.mailer.try(:test).try(:to), subject: @subject, from: Settings.mailer.try(:test).try(:to)
      end
    end
end
