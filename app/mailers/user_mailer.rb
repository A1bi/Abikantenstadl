class UserMailer < BaseMailer
  def activation(user)
    @user = user
    mail_to_user
  end
  alias_method :reset_password, :activation
  
  private
  
  def mail_to_user
    mail to: @user.email if @user.email.present?
  end
end
