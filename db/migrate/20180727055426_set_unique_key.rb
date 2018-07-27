class SetUniqueKey < ActiveRecord::Migration[5.2]
  	def change
  		change_column :courses, :url, :string, unique: true
  	end
end
