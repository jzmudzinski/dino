require 'webapi'

class Offer < ActiveRecord::Base

  def self.get_from_inspirations
    response = HTTParty.get('http://inspiracje.allegro.pl/api/grids')
    boxes = JSON.parse(response.body).collect{|grid| grid['boxes']}.collect['offer']
    Rails.logger.info boxes
  end

  def self.get_from_webapi
    api = Api::AllegroWebAPI.new
    journal = api.get_site_journal
    journal[:site_journal_array][:item].collect{|i| i if i[:change_type] == "bid"}.compact
  end
end
