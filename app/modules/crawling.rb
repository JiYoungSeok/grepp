require "open-uri"
require "nokogiri"
require 'selenium-webdriver'

module Crawling
	def parse_html(url)
		begin
			doc = Nokogiri::HTML(open(url))

			title = doc.css('div#item-header-content h1').text
			num_of_students = doc.css('div.students').text.sub('명', '').to_i
			price_area = doc.css('li.course_price')[0]
			discount = doc.css('li.course_price').css('del')[0]

			if discount.nil?
				price = price_area.css('span.woocommerce-Price-amount')[0]
				if price.nil?
					price = 0
				else
					price = price.text.sub('₩', '').sub(',', '').to_i
				end
			else
				price = price_area.css('span.woocommerce-Price-amount')[1].text.sub('₩', '').sub(',', '').to_i
			end

			course = {'url' => url, 'title' => title, 'price' => price, 'num_of_students' => num_of_students}

			return course
		rescue
			parse_html(url)
		end
	end

	def get_current_page_number(driver)
		html = driver.page_source
		doc = Nokogiri::HTML(html)

		page_number_area = doc.css('div.pagination-links span')
		current_page_number = page_number_area[0].text.to_i + page_number_area[1].text.to_i
	
		return current_page_number
	end

	def get_last_page_number(driver)
		html = driver.page_source
		doc = Nokogiri::HTML(html)

		last_page_number = doc.css('div.pag-count')[0].text.to_i
	
		return last_page_number
	end

	def get_each_page_courses_url(driver)
		html = driver.page_source
		doc = Nokogiri::HTML(html)
		urls = []

		urls_list = doc.css('div.item-title a')

		urls_list.each do |url|
			urls.push(url['href'])
		end

		return urls
	end

	def get_all_urls_by_selenium
		options = Selenium::WebDriver::Chrome::Options.new
		options.add_argument('--headless')
		driver = Selenium::WebDriver.for :chrome, options: options
		all_urls = []

		driver.get 'https://www.inflearn.com/all-courses/'
		next_page_xpath = "//div[@id='course-dir-list']/div[@id='pag-top']/div[@class='pagination-links']/a[@class='next page-numbers']"

		last_page_number = get_last_page_number(driver)

		while true
			sleep(3)
			current_page_number = get_current_page_number(driver)
			all_urls = all_urls + get_each_page_courses_url(driver)

			if current_page_number == last_page_number
				break
			end

			next_page_btn = driver.find_element(:xpath => next_page_xpath)
			next_page_btn.click
		end

		driver.quit
		return all_urls
	end
end