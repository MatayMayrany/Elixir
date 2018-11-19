defmodule Exams do
	def reduce([]) do
		[]
	end
	def reduce([x]) do
		[x]
	end
	def reduce([head | tail]) do
		[h|t] = tail
		if head == h do
			reduce(tail)
		else
			[head] ++ reduce(tail)
		end
	end
	def encode([]) do
		[]
	end
	def encode([x]) do
		case x do
			32 -> [32]
			x when x > 96 and x < 100 -> [x+23]
		end
	end
	def encode(l) do
		[head | tail] = l
		case head do
			32 -> [32] ++ encode(tail)
			97 -> [120] ++ encode(tail)
			98 -> [121] ++ encode(tail)
			99 -> [122] ++ encode(tail)
			_ when head > 99 and head < 123 ->
				[head - 3] ++ encode(tail)
 		end
 	end

 	def msort([]) do
 		[]
 	end
 	def msort(l) do
 		{l1,l2} = split(l)
 		merge(msort(l1), msort(l2))
 	end
 	def merge([]) do [] end
 	def merge([head1 | tail1], [head2 | tail2]) do
 		if head1 <= head2 do
 			[head1] ++ merge([head2 | tail2], tail1)
 		else 
 			[head2] ++ merge([head1 | tail1], tail2)
 		end
 	end
 	def split(l) do
 		split(l, [], [])
 	end
 	def split([], l1, l2) do
		{l1, l2}
	end
 	def split([head | tail], l1, l2) do
 		split(tail, [head|l2], l1)
 	end

 	defp collect() do
 		x = []
 		receive do
 			:done -> []
 			y -> [y | collect()]
 		end
 	end
 	def decode(l,x) do
 		decode(l,x,x)
 	end
 	def decode([], _, l) do
 		l
 	end
 	def decode([head | tail], {:char, char}, root) do
 		[char] ++ decode(tail, root, root)
 	end
 	def decode([head | tail], {:huf, zero, one}, root) do
 		case head do
 			0 -> decode(tail, zero, root)
 			1 -> decode(tail, one, root)
 		end
 	end

 	def test([head | tail]) do
 		head
 	end
 	def processtester() do
 		pid = spawn(fn() -> foo() end)
 		x = bar(pid, 42)
 		y = bar(pid, 32)
 		a = foo()
 		b = foo()
 		{x,y,a,b}
 	end
 	def foo() do 
 		receive do
 			{:hello, msg} -> msg
 		end
 	end 
 	def bar(pid, msg) do
 		send(pid, {:hello, msg})
 	end

 	def freq(key, []) do [{key, 1}] end
 	def freq(key, [{key, f} | tail]) do [{key, f + 1} | tail] end
 	def freq(key, [{k, f}| tail]) do [{k,f} | freq(key, tail)] end

 	def fraq(keys) do fraq(keys, []) end
 	def fraq([], l) do l end
 	def fraq([head | tail], l) do
 		l = freq(head, l)
 		fraq(tail, l) 
 	end
 	def sesame() do
 		start = spawn(fn -> closed() end)
 	end
 	def closed() do
 		receive do
 			:s -> s()
 			_ -> closed()
 		end
 	end
 	def s() do
 		receive do
 			:s
 			:e -> se()
 			_ -> closed()
 		end
 	end

 	def min({:node, val, left, right}) do
 		case right do 
 			nil -> min(left)
 			{:node, val, left, right} ->
 				
 	end
end
