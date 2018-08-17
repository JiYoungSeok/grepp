class AddDailyRevenueToSale < ActiveRecord::Migration[5.2]
	def change
		add_column :sales, :daily_revenue, :int
	end
end
