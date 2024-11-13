class AddColumnToAssos < ActiveRecord::Migration[7.1]
  def change
    # add new column without null constraint
    add_column :assos, :objet, :text

    # update existing records with a default value (active record would not know how to reverse it so use reversible block)
    reversible do |direction|
      direction.up do
        Asso.update_all(objet: 'association a but non lucratif')
      end

      direction.down do
        Asso.update_all(objet: nil )
      end
    end

    # apply null constraint to the column
    change_column_null :assos, :objet, false
  end
end
