class AddAlertemailToSection < ActiveRecord::Migration
  def change
    add_column :sections, :alert_email, :string
  end
end
