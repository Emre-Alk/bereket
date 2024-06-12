class CreateAssoTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :asso_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
