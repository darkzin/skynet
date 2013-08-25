class FileInfosController < ApplicationController
  before_action :find_parent_object

  def index
    @file_infos = @category.file_infos.all
    render :json => @file_infos.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    @file_info = @category.file_infos.new(params[:file_info])
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
    @file_info = @category.file_infos.find(params[:id])
    @file_info.destroy
    render :json => true
  end

  def show
    debugger
    @file_info = FileInfo.find(params.permit(:id)[:id])
    #uploader.retrieve_from_store!(@file_info.file.
    send_file @file_info.file.path
  end


  def find_parent_object
    categorys = ["subject", "assignment", "problem"]

    categorys.each do |category|
      if params["#{category}_id"]
        @category = category.classify.constantize.find(params["#{category}_id"])
        return true
      end
    end

    return false
  end
end
