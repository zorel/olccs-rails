class UserController < ApplicationController
  # TODO finir all this shit
  # TODO attention si user_id existant dans session mais pas dans base => 404 partout (sur tribune)
  before_filter :set_user

  def index
  end

  def save_olcc_cookie
    save = []
    cookies.each do |c|
      save << c unless c[0] == '_olccs_session'
    end
    current_user.update_column('olcc_cookie', Base64.encode64(save.to_json))
    render :nothing => true
  end

  def reload_olcc_cookie
    saved_cookie = JSON.parse(Base64.decode64(current_user.olcc_cookie))
    saved_cookie.each do |c|
      cookies[c[0]] = c[1]
    end
    redirect_to '/olcc/'
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
