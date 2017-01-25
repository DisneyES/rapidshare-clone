class UploadsController < ApplicationController
  before_action :get_upload, only: [:destroy, :download, :share]

  def index
    @uploads = current_user.uploads
  end

  def create
    @upload = current_user.uploads.new(upload_params)

    if @upload.save
      flash[:notice] = 'File was successfully uploaded.'
    else
      flash[:error] = 'Unable to upload file.'
    end
    redirect_to uploads_path
  end

  def destroy
    if @upload.destroy
      flash[:notice] = 'File was successfully deleted.'
    else
      flash[:error] = 'Unable to delete file.'
    end
      redirect_to uploads_url
  end

  def download
    if @upload.file?
      send_data @upload.file.file.path, filename: @upload.file.file.filename
    else
      flash[:error] = "File not found."
      render nothing: true
    end
  end

  def share
  end

  private

  def get_upload
    @upload = if params[:action] == 'download'
                Upload.where(id: params[:id], user_id: current_user.id).or(Upload.where(access_token: params[:id])).first
              else
                current_user.uploads.find(params[:id])
              end
  end

  def upload_params
    params.require(:upload).permit(:file)
  end
end
