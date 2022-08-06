class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :rooms
  
  varidates :message, presence: true, length: { maximum: 140 }
end
