defmodule Chopstick do
	def start do
		stick = spawn_link(fn -> available() end)
		{:stick, stick}
	end
	def available() do
		receive do
			{:request, from} -> 
				send(from, {w:granted, self()})
				gone()
			:quit  -> :ok
		end
	end
	def gone() do
		receive do
			:return -> available()
			:quit -> :ok
		end
	end

	def request({:stick, pid}, timeout) do
		send(pid, {:request, self()})
		receive do
			:granted-> 
				:ok
		after timeout -> 
			:no
		end
	end
	def return({:stick, pid}) do
		send(pid, :return)
	end
	def quit({:stick, pid}) do
		send(pid, :quit)
	end

	def request({:stick, left}, {:stick, right}, timeout) do
		send(left, {:request, self()})
		send(right, {:request, self()})
		receive do
			{:granted, left} -> granted(left, right, timeout)
			{:granted, right} -> granted(right, left, timeout)
		after timeout ->
			:no
		end
	end
	def granted(taken, other, timeout) do
		receive do
			{:granted, other} -> :ok
		after timeout ->
			return(taken)
			:no
		end
	end
end 

defmodule Philospher do
	def sleep(0) do :ok end
	def sleep(t) do
		:timer.sleep(:rand.uniform(t))
	end
	def start(hunger, right, left, name, ctrl) do
		phil = spawn_link(fn -> dreaming(hunger, left, right, name, ctrl) end)
	end
	def dreaming(0, left, right, name, ctrl) do
		IO.puts("#{name} is done eating")
		send(ctrl, :done)
	end
	def dreaming(hunger, left, right, name, ctrl) do 
		IO.puts("#{name} is dreaming")
		sleep(1000)
		waiting(hunger, left, right, name, ctrl)
	end
	def waiting(hunger, left, right, name, ctrl) do
		IO.puts("#{name} is waiting for the chopsticks")
		case Chopstick.request(left, right, 1_000) do
			:ok -> 
				IO.puts("#{name} received both chopsticks!")
				eating(hunger, left, right, name, ctrl)
			:no -> waiting(hunger, left, right, name, ctrl)
		end
		# case Chopstick.request(left, 1_000) do
		# 	:ok -> 
		# 		IO.puts("#{name} received the left chopstick")
		# 		IO.puts("#{name} is waiting for the right chopstick")
		# 		sleep(100)
		# 		case Chopstick.request(right, 1_000) do
		# 		:ok -> 
		# 			IO.puts("#{name} received the right chopstick")
		# 			eating(hunger, left, right, name, ctrl)
		# 		:no ->
		# 			IO.puts("#{name} returned the left chopstick")
		# 			Chopstick.return(left) 
		# 			waiting(hunger, left, right, name, ctrl)
		# 	end
		# 	:no -> waiting(hunger, left, right, name, ctrl)
		# end
	end
	def eating(hunger, left, right, name, ctrl) do
		IO.puts("#{name} is eating with hunger #{hunger}")
		sleep(200)
		Chopstick.return(left)
		IO.puts("#{name} returned the right chopstick")
		Chopstick.return(right) 
		IO.puts("#{name} returned the left chopstick")
		dreaming(hunger - 1, left, right, name, ctrl)
	end
end

defmodule Dinner do
	def start(), do: spawn(fn -> init() end)
	def init() do
		c1 = Chopstick.start()
		c2 = Chopstick.start()
		c3 = Chopstick.start()
		c4 = Chopstick.start()
		c5 = Chopstick.start()
		ctrl = self()
		Philospher.start(5, c1, c2, "freddy", ctrl)
		Philospher.start(5, c2, c3, "huncho98", ctrl)
		Philospher.start(5, c3, c4, "flowerboijakob", ctrl)
		Philospher.start(5, c4, c5, "simone", ctrl)
		Philospher.start(5, c5, c1, "elP", ctrl)
		wait(5, [c1, c2, c3, c4, c5])
	end

	def wait(0, chopsticks) do
		Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
	end
	def wait(n, chopsticks) do
		receive do 
			:done -> 
				wait(n - 1, chopsticks)
			:abort -> 
				Process.exit(self(), :kill)
		end
	end
end