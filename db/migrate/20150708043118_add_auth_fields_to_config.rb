class AddAuthFieldsToConfig < ActiveRecord::Migration
  def change
    add_column :configurations, :auth_enabled, :boolean
    add_column :configurations, :auth_user, :string
    add_column :configurations, :auth_pass, :string
  end
end
