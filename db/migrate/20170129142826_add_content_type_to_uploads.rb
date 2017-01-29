class AddContentTypeToUploads < ActiveRecord::Migration[5.0]
  def up
    add_column :uploads, :content_type, :string

    Rake::Task["db:update_content_type_for_upload"].invoke
  end

  def down
    remove_column :uploads, :content_type
  end
end
