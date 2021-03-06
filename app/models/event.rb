class Event < ApplicationRecord

  has_one :location, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  has_many :event_litters, dependent: :destroy
  has_many :litters, through: :event_litters

  accepts_nested_attributes_for :location

  def organizers
    self.user_events.where(is_organizer: true)
  end

  before_save :reverse_geocode, if: 'can_reverse_geocode?'  # auto-fetch address
  after_save :associate_litter

  private
  def can_reverse_geocode?
    self.location.latitude.present? && self.location.longitude.present? && !self.address
  end

  def reverse_geocode
    latlng = "#{self.location.latitude},#{self.location.longitude}"
    result = Geocoder.search(latlng).first
    process_result(result.address_components) if result.address_components
  end

  def process_result(result)
    self.address = Address.create(
      line_1: result[1] ? result[1]['long_name'] : 'Unknown Street',
      city: result[3] ? result[3]['long_name'] : 'Unknown City',
      postal_code: result[7] ? result[7]['long_name'] : 'H0H0H0',
      province: result[5] ? result[5]['long_name'] : 'BC',
      country: result[6] ? result[6]['long_name'] : 'Canada'
    )
    self.title ||= "Clean Up Event at #{self.address.street_address}"
  end

  def associate_litter
    litter_locs = Location.joins(:litter)
                          .where(litters: {cleaned: [nil, false]})
                          .near([self.location.latitude, self.location.longitude], 1.5, units: :km)

    litter_locs.each{|l| EventLitter.create(litter_id: l.litter_id, event_id: self.id)}
  end
end
