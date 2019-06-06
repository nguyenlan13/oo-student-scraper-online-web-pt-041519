
require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper

  

  def self.scrape_index_page(index_url)
#index_url = "./fixtures/student-site/index.html"
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    scraped_students = index_page.css('div.student-card').each do |student|
        student_name = student.css('h4.student-name')[0].text
        student_location = student.css('p.student-location')[0].text
        student_profile = student.css('a')[0].attr('href')
      
        students << {name: student_name, location: student_location, profile_url: student_profile}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student_profile = {}
    #student_profile[:twitter] = profile_page.css('a[href^="https://twitter.com/"]')[0].attr('href')
    #student_profile[:linkedin] = profile_page.css('a[href^="https://www.linkedin.com/"]')[0].attr('href')
    #student_profile[:github] = profile_page.css('a[href^="https://github.com/"]')[0].attr('href')

    profile_page.css('a[href^="https://twitter.com/"]').each do |match|
      student_profile[:twitter] = match.attr('href')
    end

    profile_page.css('a[href^="https://www.linkedin.com/"]').each do |match|
      student_profile[:linkedin] = match.attr('href')
    end

    profile_page.css('a[href^="https://github.com/"]').each do |match|
      student_profile[:github] = match.attr('href')
    end

    profile_page.css('.social-icon-container a').each do |match|
      match.css('img[src="../assets/img/rss-icon.png"]').each do |blog|
        student_profile[:blog] = match.attr('href')
      end
    end
    
    student_profile[:profile_quote] = profile_page.css('.profile-quote')[0].text
    student_profile[:bio] = profile_page.css('.bio-content .description-holder')[0].text.strip


    return student_profile

    #profile_page.css('.social-icon-container a').each do |social|
    #  twitter = social.css('a')[0]
    #scraped_profile_page = profile_page.css('.vitals-text-container').each do
  end

end

