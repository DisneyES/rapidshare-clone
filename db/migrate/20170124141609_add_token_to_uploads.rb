class AddTokenToUploads < ActiveRecord::Migration[5.0]
  def change
    add_column :uploads, :access_token, :string
    add_index :uploads, :access_token, unique: true
  end
end
