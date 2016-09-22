class AdoornMailer < ActionMailer::Base
  default :from => "noreply@adoorn.com"

  def welcome_email(user)
    @user = user
    mail(:to => "#{user.email}", :subject => 'Welcome Email')
  end

  def reporting_email(comment, by_user, user, type)
    @user = user
    @type=type
    @by_user = by_user
    @comment = comment
    mail(:to => "admin@adoorn.com", :subject => 'Reporting Email', :user => @user, :by_user => @by_user, :comment => @comment, :@type => type)
  end

  def rejected_blogger(user)
    @user = user
    mail(:to => "#{user.email}", :subject => 'Request Blogger Cannot Approve')
  end

  def approved_blogger(user)
    mail(:to => "#{user.email}", :subject => 'Request Blogger Approved')
  end

  def feedback_email(user, feedback)
    @user = user
    @feedback = feedback
    mail(:to => "admin@adoorn.com", :subject => 'Feedback Email', :user => @user, :feedback => @feedback)
  end

end
