class Contact < ApplicationRecord
  #Adicionado para teste da issue #4
    validates :name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, message: "não é válido" }
    validates :phone, length: { minimum: 8, maximum: 15, allow_blank: true }
  end