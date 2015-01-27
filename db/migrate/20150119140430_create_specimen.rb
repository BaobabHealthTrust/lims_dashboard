class CreateSpecimen < ActiveRecord::Migration
  def change
    create_table :specimen do |t|

      t.timestamps
    end
  end
end
