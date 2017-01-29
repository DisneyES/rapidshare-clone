class UploadsController < ApplicationController
  before_action :get_upload, only: [:destroy, :download, :share]

  def index
    @uploads = current_user.uploads
  end

  def create
    uploaded_file = params[:upload].presence && params[:upload][:file]
    redirect_to uploads_path, error: 'Unable to upload file.' and return unless uploaded_file.present?

    @upload = Upload.new.tap do |u|
      u.user = current_user
      u.file = uploaded_file.original_filename
      u.content_type = uploaded_file.content_type
    end

    if @upload.save
      FileUtils.mkdir_p(@upload.storage_path) unless Dir.exist?(@upload.storage_path)
      File.open(@upload.file_path, 'wb') {|f| f.write(uploaded_file.read) }

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
      send_file @upload.file_path, filename: @upload.file
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
end
