class Users::CreditCardsController < Users::BaseController
  def index
    @user = current_user
    gmo_member = GmoMultiPayment::Member.new(@user)
    gmo_member.create unless gmo_member.search 
    @gmo_cards = GmoMultiPayment::Card.new(@user).search
  end

  def new
  end

  def edit
    @user = current_user
    @card_no = params[:card_no]
    @card_seq = params[:id]
  end

  def create
    @user = current_user
    gmo_card = GmoMultiPayment::Card.new(@user)
    is_success = gmo_card.create(params[:card_no], params[:expire])
    if is_success
      redirect_to account_credit_cards_path
    else
      flash[:notice] = "カード情報または、有効期限が不正です。"
      render :new
    end
  end

  def update
    @user = current_user
    @card_seq = params[:id]
    gmo_card = GmoMultiPayment::Card.new(@user)
    is_success = gmo_card.update(params[:card_no], params[:expire], params[:card_seq], params[:default_flag])
    if is_success
      redirect_to account_credit_cards_path
    else
      flash[:notice] = "カード情報または、有効期限が不正です。"
      @card_no = params[:prevent_card_no]
      render :edit
    end
  end

  def destroy
    @user = current_user
    gmo_card = GmoMultiPayment::Card.new(@user)
    gmo_card.delete(params[:id])
    redirect_to account_credit_cards_path
  end
end
