class AddDailyRevenueToSale < ActiveRecord::Migration[5.2]
	def change
		add_column :sales, :daily_revenue, :int

		sql = "SELECT A.id, ((A.student_count - B.student_count) * A.price) AS revenue
			   FROM Sales A, Sales B
			   WHERE A.course_id = B.course_id AND A.update_at = B.update_at + interval '1days'"
		sale = Sale.find_by_sql(sql)

		sale.each do |s|
			Sale.find(s.id).update(daily_revenue: s.revenue)
		end
		
	end
end
