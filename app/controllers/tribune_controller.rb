class TribuneController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  before_filter :set_tribune
  def remote
    last = params[:last] || 0
    size = params[:size] || 150

    @results = @tribune.backend(last,size)

    respond_to do |format|
      format.tsv
      format.xml { render xml: to_xml(@results) }
    end

  end

  def post

  end

  def search
    size = params[:size] || 150
    if request.get?
      if params[:query].nil?
        respond_to do |format|
          format.html { render }
          format.xml { render :nothing => true}
          format.tsv { render :nothing => true}
        end
      else
        @results = @tribune.query(params[:query],size)
        respond_to do |format|
          format.html
          format.xml { render :xml => to_xml(@results) }
          format.tsv
        end
      end
    elsif request.post?
      if @query != ''
        @results = @tribune.query(params[:query],size)
        respond_to do |format|
          format.tsv
          format.xml { render :xml => to_xml(@results) }
        end
      else
        render nothing: true
      end

    end
  end

  def stats
  end

  def login
  end

  def history
  end

  def refresh
    @tribune.refresh
  end

  private
  def set_tribune
    @tribune = Tribune.find_by_name(params[:tribune]) || raise(ActiveRecord::RecordNotFound)
  end

  private

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  # @param [Array] posts
  # @return [String]
  def to_xml(posts)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => @tribune.name) {
        posts.each { |p|
          xml.post(:id => p['id'], :time => p['time']) {
            xml.info {
              xml << p['info']
            }
            xml.login {
              xml << p['login']
            }
            xml.message {
              xml << p['message']
            }
          }
        }
      }
    end
    builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end

end