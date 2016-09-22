class Users::PasswordsController < Devise::PasswordsController
  append_before_filter :assert_reset_token_passed, :only => :del, :except => :edit
  #def edit
  #self.resource = resource_class.new
  #resource.reset_password_token = params[:reset_password_token]
  #if request.env['HTTP_USER_AGENT'].downcase.match(/android|iphone/) != nil
  #  redirect_to 'Adoorn://54.94.234.54/' + edit_password_url(@resource, reset_password_token: @token)
  #end
  #end

end