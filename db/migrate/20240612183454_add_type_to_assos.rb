class AddTypeToAssos < ActiveRecord::Migration[7.1]
  def change
    add_reference :assos, :asso_type, null: false, foreign_key: true
  end
end
