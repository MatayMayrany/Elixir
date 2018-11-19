defmodule Int2Bin do
	def to_binary(0) do [] end
	def to_binary(n) do
		if rem(n,2) == 0 do
			append(to_binary(div(n,2)), [0])
		else
			append(to_binary(div(n,2)),[1])
		end
	end
	def to_better(n) do to_better(n, []) end
	def to_better(0,l) do l end
	def to_better(n,b) do
		to_better(div(n,2), [rem(n,2) | b])
	end
	def append(l1, l2) do
		l1 ++ l2
	end
end