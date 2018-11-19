defmodule Cell do
	def new(), do: spawn_link(fn -> cell(:open) end)

	defp cell(state) do
		receive do	
    		{:swap, value, from} ->
      			send(from, {:ok, state})
      			cell(value)

			{:set, value, from} -> 
				send(from, :ok)
				cell(value)
		end
	end

	def swap(cell, value) do
		send(cell, {:swap, value, self()})
		receive do
			{:ok, value} -> value
		end
	end
	def get(cell) do
		send(cell, {:get, self()})
		receive do
			{:ok, value} -> value
		end
	end

	def set(cell, value) do
		send(cell, {:set, value, self()})
		receive do
			:ok -> :ok
		end
	end

	def do_it(thing, lock) do
		case Cell.swap(lock, :taken) do
			:taken ->
				do_it(thing, lock)
			:open -> 
				do_ya_critical_thing(thing)
				Cell.set(lock, :open)
		end
	end

	def lock(id, m, p, q) do
		Cell.set(m, true)
		# returns 1 if first proccess is used and 0 if second
		other = rem(id + 1, 2)
		Cell.set(q, other)
 
		case Cell.get(p) do
			false ->
				:locked
			true ->
				case Cell.get(q) do
					^id -> 
						:locked
					^other -> 
						lock(id, m, p, q)
				end
		end
	end

	def unlock(_id, m, _p, _q) do
		Cell.set(m, false)
	end

	def semaphore(0) do
		receive do
			:release -> semaphore(1) 
		end
	end
	def semaphore(n) do
		receive do
			{:request, from} ->
				send(from, :granted)
				semaphore(n-1)
			:release ->
				semaphore(n + 1)
		end
	end
	def request(semaphore) do
		send(semaphore, {:request, self()})
		receive do
			:granted -> :ok
		end
	end

end