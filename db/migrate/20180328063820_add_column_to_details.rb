class AddColumnToDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :details, :strat_t, :datetime
    add_column :details, :name, :string

    #change_column :details, :category, :integer
    change_column :details, :category, 'integer USING CAST(category AS integer)'
    rename_column :details, :category, :category_id
  end
end
