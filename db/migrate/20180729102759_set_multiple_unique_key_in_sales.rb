class SetMultipleUniqueKeyInSales < ActiveRecord::Migration[5.2]
	def change
		change_column :sales, :update_at, :date, unique: true
		change_column :sales, :course_id, :bigint, unique: true
  	end
end
