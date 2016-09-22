#class Users::ConfirmationsController < Devise::ConfirmationsController
#  protected
#
#  def after_resending_confirmation_instructions_path_for(resource_name)
#    root_path
#  end
#
#  def show
#    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
#    yield resource if block_given?
#
#    if resource.errors.empty?
#      #set_flash_message(:notice, :confirmed) if is_flashing_format?
#      sign_in(resource) # <= THIS LINE ADDED
#      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
#    else
#      respond_with_navigational(resource.errors, :status => :unprocessable_entity) { render :new }
#    end
#  end
#end

class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      #set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in(resource) # <= THIS LINE ADDED
      AdoornMailer.welcome_email(resource).deliver
      if request.env['HTTP_USER_AGENT'].downcase.match(/android|iphone/) != nil
        set_flash_message(:notice, :confirmed)
        respond_with_navigational(resource) { redirect_to 'Adoorn://54.207.73.170/' + after_confirmation_path_for(resource_name, resource) }
        sign_in(resource)
      else
        set_flash_message(:notice, :confirmed)
        respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
      end
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity) { render :new }
    end
  end

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    root_path
  end
end
