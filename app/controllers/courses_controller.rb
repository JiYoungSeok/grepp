class CoursesController < ApplicationController
	include Crawling

	def new
		@all_urls = get_all_urls_by_selenium
		create
	end

	def create
		@all_urls.each do|url|
			course = parse_html(url)
			new_course = Course.new(title: course['title'], url: course['url'])
			new_course.save

			course_id = Course.find_by(url: course['url'].downcase).id
			new_sale = Sale.new(price: course['price'], student_count: course['student_count'], update_at: Time.now.strftime("%Y-%m-%d"), course_id: course_id)
			new_sale.save
		end

		redirect_to "/"
	end

	def index
		@all_courses = Course.all
	end

	def show
	end
end
