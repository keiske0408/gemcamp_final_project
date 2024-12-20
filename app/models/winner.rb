class Winner < ApplicationRecord
  include AASM

  mount_uploader :picture, ImageUploader
  belongs_to :item
  belongs_to :ticket
  belongs_to :user
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  belongs_to :location, class_name: "Location", foreign_key: "location_id", optional: true

  has_one_attached :picture

  aasm column: :state do
    state :won, initial: true
    state :claimed
    state :submitted
    state :paid
    state :shipped
    state :delivered
    state :shared
    state :published
    state :remove_published
    state :re_published

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: :shared, to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :remove_published
    end

    event :re_publish do
      transitions from: :remove_published, to: :published
    end
  end


end

