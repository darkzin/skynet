class FileInfosController < ApplicationController
  def index
    categorys = ["subject", "assignment", "problem"]

    if categorys.include? params[:category] && params[:category_id]
      @category = params[:category].to_s.capitalize.constantize.find(params[:category_id])
      @file_infos = @category.file_infos.all
      render :json => @file_infos.collect { |p| p.to_jq_upload }.to_json
    else
      render :json => false
    end

  end

  def create
    @file_info = File_Info.new(params[:file_info])
    if @file_info.save
      respond_to do |format|
        format.html {
          render :json => [@file_info.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@file_info.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy

    @file_info = File_Info.find(params[:id])
    @file_info.destroy
    render :json => true
  end
end
