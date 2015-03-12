class Users::CreditCardsController < Users::BaseController
  before_action :check_multi_payment_user

  def index
    @gmo_cards = GmoMultiPayment::Card.new(@user).search
  end

  def new
  end

  def edit
    @card_no = params[:card_no]
    @card_seq = params[:id]
  end

  def create
    if GmoMultiPayment::Card.new(@user).search.length < 5
      gmo_card = GmoMultiPayment::Card.new(@user)
      is_success = gmo_card.create(params[:card_no], params[:expire])
      if is_success
        redirect_to profile_credit_cards_path
      else
        flash[:notice] = "カード情報または、有効期限が不正です。"
        render :new
      end
    else
      redirect_to profile_credit_cards_path
    end
  end

  def update
    @card_seq = params[:id]
    gmo_card = GmoMultiPayment::Card.new(@user)
    is_success = gmo_card.update(params[:card_no], params[:expire], params[:card_seq], params[:default_flag])
    if is_success
      redirect_to profile_credit_cards_path
    else
      flash[:notice] = "カード情報または、有効期限が不正です。"
      @card_no = params[:prevent_card_no]
      render :edit
    end
  end

  def destroy
    gmo_card = GmoMultiPayment::Card.new(@user)
    gmo_card.delete(params[:id])
    redirect_to profile_credit_cards_path
  end

  private
    def check_multi_payment_user
      @user = current_user
      gmo_member = GmoMultiPayment::Member.new(@user)
      if gmo_member.search
        is_success = true
      else
        is_success = gmo_member.create
      end
      if !is_success
        session.delete(:user)
        redirect_to new_user_session_path
      end
    end
end
