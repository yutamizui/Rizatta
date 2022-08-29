class Ticket < ApplicationRecord
    belongs_to :user,  dependent: :destroy
end
