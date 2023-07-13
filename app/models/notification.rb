class Notification < ApplicationRecord
  belongs_to :end_user
  belongs_to :subject
end
