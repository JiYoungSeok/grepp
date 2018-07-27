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
			
			if new_course.save
				sleep(1)
			else
				next
			end
		end

		redirect_to "/"
	end

	def index
		@all_courses = Course.all
	end

	def show
	end
end
