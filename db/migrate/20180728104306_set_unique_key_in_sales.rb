class SetUniqueKeyInSales < ActiveRecord::Migration[5.2]
	def change
		change_column :sales, :update_at, :date, unique: true
	end
end
