class RemoveDefaultNameFromConfig < ActiveRecord::Migration
  def up
    change_column_default :configurations, :name, nil
  end

  def down
    change_column_default :configurations, :name, "ping"
  end
end
