class SalesController < ApplicationController
  	def index
  		sql = "SELECT A.update_at, SUM((A.student_count - B.student_count) * A.price) AS revenue \
  			   FROM Sales A, Sales B \
  			   WHERE A.course_id = B.course_id AND A.update_at = B.update_at + interval '1 days'\
  			   GROUP BY A.update_at"
  		@overview_daily_revenue	= Sale.find_by_sql(sql)
 	end

  	def show
  		sql = "SELECT Courses.title, Courses.url, Sales.student_count, Sales.price \
  			   FROM Courses, Sales \
  			   WHERE Courses.id = Sales.course_id"
  		@detail_daily_revenue = Sale.where(update_at: params[:update_at]).find_by_sql(sql)
  	end
end
