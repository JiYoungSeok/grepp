class Course < ApplicationRecord
	validates_uniqueness_of :url
	has_many :sales, dependent: :destroy
end
