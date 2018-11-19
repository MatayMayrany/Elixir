defmodule Tic do
	
	def first do
	receive do
		{:tic, x} -> 
			IO.puts("tic: #{x}")
			second()
	end
	end
	defp second do
		receive do
			{:tac, x} ->
			IO.puts("tac: #{x}")
			last()
			{:toe, x} ->
			IO.puts("toe: #{x}")
			last()
		end
	end
end