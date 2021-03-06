class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :event_id, uniqueness: {
    scope: :user_id,
    message: 'You have already joined this event.'
  }
end
