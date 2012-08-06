class UserController < ApplicationController
  # TODO finir all this shit
  # TODO attention si user_id existant dans session mais pas dans base => 404 partout (sur tribune)
  before_filter :set_user

  def index
  end

  def save_olcc_cookie
    current_user.update_attribute('olcc_cookie', cookies)
  end

  def reload_olcc_cookie
    cookies = current_user.olcc_cookie
  end

  def destroy_olcc_cookie
    current_user.update_attribute('olcc_cookie', "")
  end

  private
  def set_user
    unless current_user
      redirect_to root_url
    end
  end


end
