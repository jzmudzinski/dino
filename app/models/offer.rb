class Offer < ActiveRecord::Base
  def self.get_from_inspirations
    response = HTTParty.get('http://inspiracje.allegro.pl/api/grids')
    boxes = JSON.parse("{\"result\":\"#{response.body}\"}").collect{|grid| grid['boxes']}.collect['offer']
    Rails.logger.info boxes
  end
end
