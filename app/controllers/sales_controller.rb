class SalesController < ApplicationController
  	def index
  		sql = "SELECT A.update_at, SUM((A.student_count - B.student_count) * A.price) AS revenue \
  			   FROM Sales A, Sales B \
  			   WHERE A.course_id = B.course_id AND A.update_at = B.update_at + interval '1 days'\
  			   GROUP BY A.update_at"
  		
  		@overview_daily_revenue	= Sale.find_by_sql(sql)

  		@monthly_revenue_predict = 0
  		@overview_daily_revenue.each do |daily|
  			@monthly_revenue_predict += daily.revenue * 0.3
  		end
  		# @monthly_revenue_predict = ((@monthly_revenue_predict / @overview_daily_revenue.size * 9 * 365) / (10 * 12)).to_i
 	end

  	def show
  		sql = "SELECT Courses.id, Courses.title, Courses.url, A.student_count, A.price, ((A.student_count - B.student_count) * A.price) AS revenue \
  			   FROM Courses, Sales A, Sales B \
  			   WHERE Courses.id = A.course_id AND A.course_id = B.course_id AND A.update_at = B.update_at + interval '1 days' AND A.update_at = '#{params[:update_at]}' \
  			   ORDER BY revenue DESC"

  		@detail_daily_revenue = Course.joins(:sales).find_by_sql(sql)
  	end
end
