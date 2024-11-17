class Location < ApplicationRecord
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  enum genre: { home: 0, office: 1 }

  validates :genre, presence: true
  validates :name, presence: true
  validates :street_address, presence: true
  validates :phone_number, presence: true
  validate :ensure_one_default

  before_save :unset_previous_default, if: :is_default?

  private
  def unset_previous_default
    user.locations.where(is_default: true).update_all(is_default: false)
  end

  def ensure_one_default
    if user.locations.count > 1 && user.locations.where(is_default: true).empty?
      errors.add(:is_default, "At least one address must be set as default.")
    end
  end
end
