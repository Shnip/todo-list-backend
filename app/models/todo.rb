class Todo < ApplicationRecord
  belongs_to :user
  has_many_attached :todo_files
end
