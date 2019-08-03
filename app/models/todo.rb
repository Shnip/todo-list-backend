class Todo < ApplicationRecord
  belongs_to :user
  has_many_attached :attachments

  validates :title, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: ["in progress", "complete"],
    message: "%{value} is not valid" }
end
