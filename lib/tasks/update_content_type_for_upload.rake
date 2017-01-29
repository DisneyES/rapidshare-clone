namespace :db do
  desc "Update file name and content type for existing uploaded records"
  task update_content_type_for_upload: :environment do
    IMAGE_EXTN = ['png', 'jpg', 'jpeg', 'gif']

    Upload.reset_column_information
    Upload.all.each do |upload|
      if upload.file.present?
        extn = File.extname(upload.file)
        extn.slice!(0)
        if extn.present?
          content_type = (IMAGE_EXTN.include?(extn) ? 'image/' : 'application/').concat(extn)
          upload.content_type = content_type
        end

        upload.save
      end
    end
  end
end
