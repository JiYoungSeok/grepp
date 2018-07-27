class Course < ApplicationRecord
	validates_uniqueness_of :url
end
