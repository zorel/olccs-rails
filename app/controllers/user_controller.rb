class UserController < ApplicationController
  # TODO finir all this shit
  # TODO attention si user_id existant dans session mais pas dans base => 404 partout (sur tribune)
  before_filter :set_user

  def index
  end

  def save_olcc_cookie
    save = []
    cookies.each do |c|
      save << c
    end
    current_user.update_attribute('olcc_cookie', save.to_json)
    render :text => save.to_yaml
  end

  def reload_olcc_cookie
    saved_cookie = JSON.parse(current_user.olcc_cookie)
    saved_cookie.each do |c|
      cookies[c[0]] = c[1]
    end
    render :text => cookies.to_yaml
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
