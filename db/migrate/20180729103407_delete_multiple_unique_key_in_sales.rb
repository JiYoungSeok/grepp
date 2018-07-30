class DeleteMultipleUniqueKeyInSales < ActiveRecord::Migration[5.2]
	def change
		change_column :sales, :update_at, :date, unique: false
		change_column :sales, :course_id, :bigint, unique: false
  	end
end
