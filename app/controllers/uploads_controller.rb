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
    unless @upload.present?
      flash[:error] = "File not found."
      redirect_to uploads_url and return
    end

    if @upload.destroy
      flash[:notice] = 'File was successfully deleted.'
    else
      flash[:error] = 'Unable to delete file.'
    end
      redirect_to uploads_url
  end

  def download
    if @upload.present? && @upload.file?
      send_file @upload.file.file.path, filename: @upload.exported_name, type: @upload.content_type, disposition: :attachment
    else
      flash[:error] = "File not found."
      redirect_to uploads_url
    end
  end

  def share
    head :not_found and return unless @upload.present?
  end

  private

  def get_upload
    uploads = Upload.where(id: params[:id], user_id: current_user.id)
    @upload = if params[:action] == 'download'
                uploads.or(Upload.where(access_token: params[:id])).first
              else
                uploads.first
              end
  end

  def upload_params
    params.require(:upload).permit(:file)
  end
end
