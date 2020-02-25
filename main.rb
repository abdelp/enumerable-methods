module Enumerable
  def my_each
		return enum_for(:my_each) unless block_given?

		for i in 0..length-1 do
			yield(self[i])
		end
  end

	def my_each_with_index
		return enum_for(:my_each_with_index) unless block_given?

	  for i in 0..length-1 do 
			yield(self[i], i)
    end
  end

	def my_select
		return enum_for(:my_select) unless block_given?

		items_selected = []

		my_each do |item|
			items_selected << item if yield(item)
		end

		items_selected
  end

	def my_all?
		if block_given?
			my_each do |item|
				return false unless yield(item)	
			end
		else
			my_each do |item|
				return false unless item
			end
		end
		true
	end

	def my_any?
		if block_given?
			my_each do |item|
				return true if yield(item)
			end
		else
			my_each do |item|
				return true if item
			end
		end
		false
	end

	def my_none?
		my_each
end
