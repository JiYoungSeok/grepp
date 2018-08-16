class CoursesController < ApplicationController
	include Crawling

	def index
        sql = "SELECT Courses.id, Courses.title, Courses.url, A.student_count, A.price, ((A.student_count - B.student_count) * A.price) AS total_revenue
               FROM Courses, Sales A, Sales B
               WHERE Courses.id = A.course_id AND A.course_id = B.course_id AND A.update_at = B.update_at + interval '1 days'
               ORDER BY Courses.id DESC"

        @detail_course_revenue = Course.find_by_sql(sql)
	end

	def new
		create
	end

	def create
		Crawling.auto_crawling
		redirect_to "/"
	end

	def show
		sql = "SELECT (A.student_count - B.student_count) AS student_change, A.student_count, A.update_at
		   	   FROM Sales A, Sales B
		   	   WHERE A.course_id = #{params[:id]} AND A.course_id = B.course_id AND A.update_at = B.update_at + interval '1 days' AND A.update_at > now() + interval '-7 days'
		   	   GROUP BY A.update_at, A.course_id, A.student_count, B.student_count
		   	   ORDER BY A.update_at
		   	   LIMIT 7"

		@course_student_change = Sale.find_by_sql(sql)		   	 
	end
end
