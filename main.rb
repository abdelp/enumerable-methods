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
		if block_given?
			my_each do |item|
				return false if yield(item)
			end
		else
			my_each do |item|
				return false if item
			end
		end
		true
	end

	def my_count(p1 = nil)
		count = 0

		if !p1.nil?
			my_each do |item|
				count += 1 if item == p1
			end
		elsif block_given?
			my_each do |item|
				count += 1 if yield(item)
			end
		else
			my_each do |item|
				count += 1
			end
		end
		count
	end
end
