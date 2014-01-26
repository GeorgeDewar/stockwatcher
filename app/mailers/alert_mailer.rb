class AlertMailer < ActionMailer::Base
  default from: "george@dewar.co.nz"

  def stock_alert(user)
  	@user = user
  	mail(to: @user.email, subject: 'Alert!')
  end
end
