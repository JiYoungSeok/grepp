class CreateSales < ActiveRecord::Migration[5.2]
  	def change
    	create_table :sales do |t|
    		t.integer	:price
    		t.integer	:student_count
    		t.date		:update_at
    	end
  	end
end
