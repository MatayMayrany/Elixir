defmodule Sorting do
	def isort(l) do
		isort(l,[])
	end
	def isort([], l) do
		l
	end
	def isort([head | tail], sorted) do
		isort(tail, insert(head, sorted))
	end
	def insert(x,[]) do
		[x]
	end
	def insert(x,[head|tail]) do
		if x <= head do
			[x] ++ [head | tail]
		else 
			[head] ++ insert(x,tail)
		end
	end


	def msort([]) do
		[]
	end
	def msort([x]) do [x] end
	def msort(l) do
		{l1, l2} = msplit(l,[],[])
		merge(msort(l1), msort(l2))
	end
	def merge([],[]) do [] end
	def merge([],l) do l end
	def merge(l,[]) do l end
	def merge([head | tail], [head1 | tail1]) do
		if head <= head1 do
			[head | merge(tail, [head1 | tail1])]
		else 
			[head1 | merge(tail1, [head | tail])]
		end
	end
	def msplit([], l1, l2) do
		{l1, l2}
	end
	def msplit([head | tail], l1, l2) do 
		msplit(tail, [head|l2], l1)
	end

	def qsort([]) do [] end
	def qsort([p | l]) do
		{l1, l2} = qsplit(p, l, [], [])
		small = qsort(l1)
		large = qsort(l2)
		append(small, [p | large])
	end
	def qsplit(_, [], left ,right) do
		{left, right}
	end
	def qsplit(p, [head | tail], left, right) do
		if head <= p do
			qsplit(p, tail, [head|left], right)
		else 
			qsplit(p, tail, left, [head | right])
		end 
	end
	def append(small, []) do
		small
	end
	def append([], large) do 
		large
	end
	def append(small, large) do
		small ++ large
	end
end
