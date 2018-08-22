class CoursesController < ApplicationController
   include InflearnCrawling

   def index
      @each_course_accumulated_revenue = []
      @each_course_revenue = Sale.group(:course_id).sum(:daily_revenue).sort_by {|key, value| value}.reverse
      @each_course_revenue.each do |key, value|
         course = Course.find(key)
         sale = Sale.find_by(course_id: key,
                             update_at: Time.now.strftime("%Y-%m-%d"))
         unless sale.nil?
            each_course = {id: key,
                           url: course.url,
                           title: course.title,
                           price: sale.price,
                           student_count: sale.student_count,
                           accumulated_revenue: value}
         end
         @each_course_accumulated_revenue << each_course
      end

      puts @each_course_accumulated_revenue
   end

   def new
      create
   end

   def create
      InflearnCrawling.inflearn_crawling
      GoormCrawling.goorm_crawling
      redirect_to "/"
   end

   def show
      sql = "SELECT (A.student_count - B.student_count) AS student_change, A.student_count, A.update_at
		   	   FROM Sales A, Sales B
		   	   WHERE A.course_id = #{params[:id]} AND A.course_id = B.course_id AND A.update_at = B.update_at + interval '1 days' AND A.update_at > now() + interval '-7 days'
		   	   GROUP BY A.update_at, A.course_id, A.student_count, B.student_count
		   	   ORDER BY A.update_at"

      @course_student_change = Sale.find_by_sql(sql)
   end
end
