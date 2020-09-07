class Sptag < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: { scope: :user_id, message: "You already have this tag" }
end
