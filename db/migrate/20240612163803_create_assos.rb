class CreateAssos < ActiveRecord::Migration[7.1]
  def change
    create_table :assos do |t|
      t.string :name
      t.string :code_nra
      t.string :code_siret
      t.string :code_siren
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
