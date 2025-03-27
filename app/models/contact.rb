class Contact < ApplicationRecord
    validates :name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
    validates :phone, length: { minimum: 8, maximum: 15, allow_blank: true }
  end