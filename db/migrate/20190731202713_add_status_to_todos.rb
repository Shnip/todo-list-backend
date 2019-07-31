class AddStatusToTodos < ActiveRecord::Migration[6.0]
  def change
    add_column :todos, :status, :string, null: false, default: 'in progress'
  end
end
