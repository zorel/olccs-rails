# encoding: UTF-8
#
## Controleur de gestion de l'utilisateur et de ses préférences. Se référer à l'aide pour plus d'infos
class UserController < ApplicationController
  # TODO finir all this shit
  # TODO attention si user_id existant dans session mais pas dans base => 404 partout (sur tribune)
  before_filter :set_user

  #accepts_nested_attributes_for :rule

  # Voir l'aide
  def index

  end

  # Voir l'aide
  def edit_rules
    @user = current_user
    @rules = @user.rules
    #raise current_user.to_yaml
    #
    #index = Tire.index('shoop') do
    #  md5 = Digest::MD5.hexdigest("#{c.provider}#{c.uid}")
    #  register_percolator_query('plopify', usermd5: md5) { string 'histoire' }
    #end
    #3.times {@current_user.rules.build}
    render "edit_rules"
  end

  def save_rules
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {
          flash[:notice] = "Rules successfully updated"
          redirect_to :action => 'edit_rules'
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  # Voir l'aide
  def save_olcc_cookie
    save = []
    cookies.each do |c|
      save << c unless c[0] == '_olccs_sessionid'
    end
    current_user.update_column('olcc_cookie', Base64.encode64(save.to_json))
    flash[:notice]='Cookies sauvegardés'
    redirect_to :root
  end

  # Voir l'aide
  def reload_olcc_cookie
    saved_cookie = JSON.parse(Base64.decode64(@current_user.olcc_cookie))
    saved_cookie.each do |c|
      cookies[c[0]] = c[1]
    end
    flash[:notice]='Cookies rechargés'
    redirect_to :root
  end

  # Voir l'aide
  def destroy_olcc_cookie
    current_user.update_column('olcc_cookie', "")
  end

  private
  def set_user
    unless current_user
      redirect_to :root
    end
  end


end
