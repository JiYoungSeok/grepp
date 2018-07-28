class Sale < ApplicationRecord
	validates_uniqueness_of :update_at
	belongs_to :course
end
