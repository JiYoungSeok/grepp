class DeleteUniqueKeyInSales < ActiveRecord::Migration[5.2]
  	def change
  		change_column :sales, :update_at, :date, unique: false
  	end
end
