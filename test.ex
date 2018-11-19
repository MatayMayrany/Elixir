defmodule Test do
	def double(n) do
		2 * n
	end
	def convert(n) do 
		(n - 32)/1.8
	end
	def rectangle(n, p) do
		n*p
	end
	def square(n) do
		rectangle(n,n)
	end
	def circle(n) do
		n*3.142
	end
	def product(n,m) do 
		case m do
			0 ->
				0
			_ ->
				n + product(n, m-1)	
		end
	end
	def product_cond(n,m) do 
		cond do
			m == 0 ->
				0
			true ->
				n + product(n, m-1)	
		end
	end
	def product_clauses(0,_) do
		0
	end
	def product_clauses(n,m) do
		product_clauses(n-1,m) + m
	end
	def exp(x,n) do
		case n do
			0 -> 
				1
			1 -> 
				x
			_ -> product(x,exp(x,n-1))
		end
	end
	def exp2(x,0) do
		1
	end
	def exp2(x,1) do
		x
	end
	def exp2(x,n) do
		case rem n,2 do
			0 -> 
				exp2(x,div(n,2))*exp2(x,div(n,2))
			_ -> 
				x*exp2(x,n-1)
		end
	end
	def nth(n,l) do
		[h|t] = l
		if n == 1 do
			h
		else 
			nth(n-1,t)
		end 
	end
	def len([]) do
		0
	end
	def len([x]) do
		1
	end
	def len(l) do
		[h|t] = l
		1 + len(t)
	end
	def sum([]) do
		0
	end
	def sum([x]) do
		x
	end
	def sum(l) do
		[h|t] = l
		h + sum(t)
	end
	def duplicate([]) do 
		[]
	end 
	def duplicate(l) do
		[h|t] = l 
		[h,h|duplicate(t)]
	end
	def add(x,[]) do
		[x]
	end
	def add(x,l) do
	 	if contains(x,l) do
	 		l
		else
			l ++ [x]
		end
	end
	def contains(_,[]) do 
		false
	end
	def contains(x,l) do 
		[h|t] = l
		if h == x do
			true
		else 
			contains(x,t)
		end
	end
	def remove(_,[]) do
		[]
	end
	def remove(x,l) do
		[h|t] = l
		if contains(x,l) do
			if h == x do
				remove(x,t)
			else
				[h] ++ remove(x,t)
			end	
		else
			l
		end
	end
	def unique([])do
		[]
	end
	def unique(l) do
		[h|t] = l
		if contains(h,t) do
			unique(t)
		else
			[h] ++ unique(t)
		end
	end

	def pack([])do
		[]
	end
	def pack([head | tail]) do
		[match(head, [head | tail])] ++ pack(remove(head, [head |tail]))
	end

	# retturn a list of all instances of an element in a bigger list
	def match(_,[]) do
		[]
	end
	def match(x, [head | tail]) do
		if x == head do
			[x] ++ match(x, tail)
		else
			match(x, tail)
		end
	end

	def reverse([]) do
		[]
	end
	def reverse([head | tail]) do 
		reverse(tail) ++ [head]
	end
end