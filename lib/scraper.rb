require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    value_from_open = Nokogiri::HTML(open(index_url))

    array_hashes = []
    
    value_from_open.css('.student-card').each do |item|
      name_value = item.css(".student-name").text
      location_value = item.css(".student-location").text
      profile_url_value = item.css("a").attribute("href").value

      new_hash = {
        :name => name_value,
        :location => location_value,
        :profile_url => profile_url_value
      }

      array_hashes << new_hash

    end

    array_hashes
  end

  def self.scrape_profile_page(profile_url)

    hash_of_attributes = {}

    value_from_open = Nokogiri::HTML(open(profile_url))

    value_from_open.css('.social-icon-container').each do |item|

      item.css("a").each do |item|

        link_value = item.attribute("href").value
    
        if link_value.include?("twitter")
          hash_of_attributes[:twitter] = link_value
        elsif link_value.include?("linkedin")
          hash_of_attributes[:linkedin] = link_value
        elsif link_value.include?("github")
          hash_of_attributes[:github] = link_value
        else
          hash_of_attributes[:blog] = link_value
        end
      end
    end

    profile_quote_value = value_from_open.css('.vitals-text-container .profile-quote').text
    hash_of_attributes[:profile_quote] = profile_quote_value

    bio_value = value_from_open.css('.details-container .bio-content .description-holder p').text
    hash_of_attributes[:bio] = bio_value

    hash_of_attributes
  end

end

