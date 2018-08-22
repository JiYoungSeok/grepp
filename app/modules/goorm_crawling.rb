require "open-uri"
require "nokogiri"
require 'selenium-webdriver'

module GoormCrawling
   def self.parse_html(url)
      url = "https://edu.goorm.io" + URI.escape(url)
      doc = Nokogiri::HTML(open(url))

      title = doc.css('h1._2Mxsr1MG1WDmFJAWqhIy5Y').text
      student_count = doc.css('div.zXyBPsEtykSRKI4l2JbQS')[2].text.to_i
      price = doc.css('span._1sQCsEkDBK2RmjQbAvo-Wq').text.sub(',', '').to_i

      course = {'url' => url, 'title' => title, 'price' => price, 'student_count' => student_count}

      return course
   end

   def self.get_all_urls
      all_urls = []

      for i in 1..4
         page_url = "https://edu.goorm.io/category/programming?page=" + i.to_s + "&sort=newest"
         doc = Nokogiri::HTML(open(page_url))
         each_course_url_set = doc.css('a.CcD7tOfD7Cp8uwaOcxE3x')
         each_course_url_set.map {|element| element['href']}.compact

         each_course_url_set.each do |each_course|
            all_urls = all_urls << each_course.values[1]
         end
      end

      return all_urls
   end

   def self.goorm_crawling
      all_urls = get_all_urls

      all_urls.each do |url|
         course = parse_html(url)
         new_course = Course.new(title: course['title'],
                                 url: course['url'],
                                 site: "goorm")
         new_course.save

         course_id = Course.find_by(url: course['url']).id
         prev_student_count = Sale.find_by(course_id: course_id, update_at: Date.yesterday)
         if prev_student_count
            daily_revenue = (course['student_count'].to_i - prev_student_count.student_count.to_i) * course['price'].to_i
            new_sale = Sale.new(price: course['price'],
                                student_count: course['student_count'],
                                update_at: Time.now.strftime("%Y-%m-%d"),
                                daily_revenue: daily_revenue,
                                course_id: course_id)
         else
            new_sale = Sale.new(price: course['price'],
                                student_count: course['student_count'],
                                update_at: Time.now.strftime("%Y-%m-%d"),
                                course_id: course_id)
         end

         new_sale.save
      end
   end
end