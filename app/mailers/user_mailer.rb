class UserMailer < ApplicationMailer
  default from: Settings.mailer.try(:user_mailer).try(:from),
    bcc: Settings.mailer.try(:user_mailer).try(:bcc)
  add_template_helper(ApplicationHelper)
  before_filter :user_mailer_smtp_settings
  after_filter :send_mail

  include ApplicationHelper

  def send_order_accepted_notification(order)
    user_id = order.user_id
    @profile = Profile.find_by(user_id: user_id)
    @payment = order.single_order_detail.payment
    @detail = order.single_order_detail
    @address = @detail.address

    sleep 1
    @to = order.user.id
  end

  def order_canceled_notification(item_id)
    @item = SingleLineItem.find(item_id)
    @payment = @item.single_order_detail.payment
    @profile = Profile.find_by(user_id: @payment.user_id)
    @variant = Variant.find_by(id: @item.variant_id)

    sleep 1
    @to = @payment.user.email
  end

  def item_return_accepted_notification(item_id)
    @item = SingleLineItem.find(item_id)
    @payment = @item.single_order_detail.payment
    @profile = Profile.find_by(user_id: @payment.user_id)
    @variant = Variant.find_by(id: @item.variant_id)

    sleep 1
    @to = @payment.user.email
  end

  def send_items_shipped_notification(user, profile, shipment)
    sleep 1
    @to = profile.email
  end

  private

    def user_mailer_smtp_settings
      ActionMailer::Base.smtp_settings = {
        :address => "smtp.gmail.com",
        :port => 587,
        :domain => 'gmail.com',
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
