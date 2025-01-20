class User < ApplicationRecord
    validates :name, presence: true, length: { maximum: 20 }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    
end
