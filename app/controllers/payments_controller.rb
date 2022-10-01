class PaymentsController < ApplicationController

  def index
    @branches = company_admin.branches
    if params[:target_date].present?
      @target_date = params[:target_date].to_datetime.in_time_zone
    else
      @target_date = Date.today
    end
    @payments = Payment.where("payday >= ?", @target_date.beginning_of_month).where("payday <= ? ", @target_date.end_of_day).where(branch_id: params[:branch_id])
  end

  def customer_registration
    if current_user.present?
      @user = current_user
    end
 
    begin
      if @user.present?
        Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
        customer = Payjp::Customer.create(
          id: "rizatta" + @user.id.to_s,
          description: @user.name,
          card: params['payjp-token'],
          email: @user.email
        )
        @user.update(customer_id: "rizatta" + @user.id.to_s )
      end

    rescue Payjp::CardError => e
        flash[:alert] = "クレジットカードの認証ができませんでした。1"
        body = e.json_body
        err  = body[:error]

        puts "Status is: #{e.http_status}"
        puts "Type is: #{err[:type]}"
        puts "Code is: #{err[:code]}"
        # param is '' in this case
        puts "Param is: #{err[:param]}"
        puts "Message is: #{err[:message]}"

    rescue Payjp::InvalidRequestError => e
      flash[:alert] = "クレジットカードの認証ができませんでした。"
    rescue Payjp::AuthenticationError => e
      flash[:alert] = "認証キーのエラーが発生しました。運営にお問い合わせください。"
    rescue Payjp::APIConnectionError => e
      flash[:alert] = "接続エラーが発生しました。再度やり直してください。"
    rescue Payjp::PayjpError => e
      flash[:alert] = "通常エラーが発生しました。運営にお問い合わせください。"
    rescue => e
      flash[:alert] = "エラーが発生しました。運営にお問い合わせください。"
    end

    if flash.now[:alert].present?
        render 'sales_items/list'
    else
        flash[:notice] = "カード情報を登録しました。チケットをご購入いただけます。"
        redirect_to list_sales_items_path(branch_id: @user.branch_id)
    end
  end

  # アイテム購入
  def charge
    @sales_item = SalesItem.find(params[:id])
    price = @sales_item.price
    number_of_ticket = @sales_item.number_of_ticket

    Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
    begin
      Payjp::Charge.create(
        amount: price,
        currency: 'jpy',
        customer: "rizatta" + current_user.id.to_s,
      )
    rescue Payjp::AuthenticationError => e
        flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：１)"
    rescue Payjp::APIConnectionError => e
        flash[:alert] = "接続エラーが発生しました。再度やり直してください。(お問い合わせ番号：２)"
    rescue Payjp::PayjpError => e
        flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：３)"
    rescue => e
        flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：４)"
    end
    if flash[:alert].present?
      render 'sales_items/list'
    else
      number_of_ticket.times do
        Ticket.create(
          user_id: current_user.id,
          expired_at: (Date.today + @sales_item.effective_date).in_time_zone.end_of_day
        )
      end
      Payment.create(
        user_id: current_user.id,
        payday: Date.today,
        amount: price,
        branch_id: current_user.branch_id,
        sales_item_id: @sales_item.id
      )
      redirect_to list_sales_items_path(branch_id: current_user.branch_id), notice: t('activerecord.attributes.ticket.purchase_completed')
    end
  end

  def payjpcard_update
    customer_id = "rizatta#{current_user.id}"

    Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
    customer = Payjp::Customer.retrieve(
        customer_id
    )
    customer.cards.create(
        card: params['payjp-token'],
        default: true
    )
    if flash[:alert].present?
        render 'list_sales_items/index'
    else
      flash[:notice] = "カード情報を変更しました。"
      redirect_to list_sales_items_path(branch_id: current_user.branch_id)
    end
  end


  def payjp_webhook
  end
end
