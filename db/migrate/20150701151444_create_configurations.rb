class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string :name
      t.string :host, :default => "http://localhost:3000"
      t.string :endpoint, :default => "/api/"
      t.string :method, :default => "GET"
      t.text :payload
    end
  end
end
