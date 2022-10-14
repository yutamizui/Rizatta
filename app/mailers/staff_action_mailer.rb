class StaffActionMailer < ApplicationMailer
  default :from => 'info@rizatta.com'
  
# send a signup email to the user, pass in the user object that   contains the user's email address
  def reservation_notifier(reservation, timeframe)
    @reservation = reservation
    @timeframe = timeframe
    @branch = @timeframe.branch
    mail(
      :to => @branch.email,
      :subject =>  "ご予約を受け付けました"
    )
  end

  def reservation_cancel_notifier(reservation, timeframe)
    @reservation = reservation
    @timeframe = timeframe
    @branch = @timeframe.branch
    mail(
      :to => @branch.email,
      :subject =>  "ご予約のキャンセルを受け付けました"
    )
  end
end