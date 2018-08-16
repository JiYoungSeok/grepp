require "open-uri"
require "nokogiri"
require 'selenium-webdriver'

module Crawling
	def self.parse_html(url)
		begin
			doc = Nokogiri::HTML(open(url))

			title = doc.css('div#item-header-content h1').text
			student_count = doc.css('div.students').text.sub('명', '').to_i
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

			course = {'url' => url, 'title' => title, 'price' => price, 'student_count' => student_count}

			return course
		rescue
			parse_html(url)
		end
	end

	def self.get_current_page_number(driver)
		html = driver.page_source
		doc = Nokogiri::HTML(html)

		page_number_area = doc.css('div.pagination-links span')
		current_page_number = page_number_area[0].text.to_i + page_number_area[1].text.to_i
	
		return current_page_number
	end

	def self.get_last_page_number(driver)
		html = driver.page_source
		doc = Nokogiri::HTML(html)

		last_page_number = doc.css('div.pag-count')[0].text.to_i
	
		return last_page_number
	end

	def self.get_each_page_courses_url(driver)
		html = driver.page_source
		doc = Nokogiri::HTML(html)
		urls = []

		urls_list = doc.css('div.item-title a')

		urls_list.each do |url|
			urls.push(url['href'])
		end

		return urls
	end

	def self.sort_by_alphabetical(driver)
		sort_xpath = "//li[@id='course-order-select']"
		sort_btn = driver.find_element(:xpath => sort_xpath)
		sort_btn.click
		sleep(3)
		sort_by_alphabetical_xpath = "//option[@value='alphabetical']"
		sort_by_alphabetical_btn = driver.find_element(:xpath => sort_by_alphabetical_xpath)
		sort_by_alphabetical_btn.click
		sleep(3)
	end

	def self.get_all_urls_by_selenium
		options = Selenium::WebDriver::Chrome::Options.new
		options.add_argument('--headless')
		driver = Selenium::WebDriver.for :chrome, options: options
		all_urls = []

		driver.get 'https://www.inflearn.com/all-courses/'
		sort_by_alphabetical(driver)

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

	def self.auto_crawling
		all_urls = get_all_urls_by_selenium

		all_urls.each do|url|
			course = parse_html(url)
			new_course = Course.new(title: course['title'], url: course['url'])
			new_course.save

			course_id = Course.find_by(url: course['url'].downcase).id
			new_sale = Sale.new(price: course['price'], student_count: course['student_count'], update_at: Time.now.strftime("%Y-%m-%d"), course_id: course_id)
			new_sale.save
		end
	end
end