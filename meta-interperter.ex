defmodule Env do 
	def new() do
		[]
	end 

	def add(id, str, env) do
		[{id, str} | env]
	end

	def lookup(id, []) do
		nil
	end
	def lookup(id, [{headId, headStr} | rest]) do
		if id == headId do
			{id, headStr}
		else
			lookup(id, rest)
		end
	end

	def remove([], env) do env end
	def remove([head | tail], env) do
		case lookup(head, env) do
		  nil -> remove(tail, env)
		  _ -> remove(tail, removeID(head, env))
		end
	end
	def removeID(id, [{headId, headStr} | rest]) do
		if id == headId do
			rest
		else	
			[{headId, headStr} | removeID(id, rest)]
		end
	end

	def closure(var, env) do
		closure(var, env, [])
	end
	def closure([], env, acc) do
		acc
	end
	def closure([id | vars], env, acc) do
		case lookup(id, env) do
			{id, value} -> 
				acc = [{id, value} | acc]
				closure(vars, env, acc)
			nil -> :error
		end
	end
end

defmodule Eager do
	def eval_expr({:atm, id}, _) do {:ok, id} end
	def eval_expr({:var, id}, env) do 
		case Env.lookup(id, env) do
			nil -> :error
			{_, str} -> {:ok, str} 
		end
	end
	def eval_expr({:cons, first, second}, env) do
		case eval_expr(first, env) do
			:error -> 
				:error
			{:ok, firstStr} ->
				case eval_expr(second, env) do
					:error -> 
						:error
					{:ok, secondStr} -> 
						{:ok, [firstStr | secondStr]}
				end
		end
	end
	def eval_expr({:case, expr, cls}, env) do
		case eval_expr(expr, env) do
			:error -> :error
			{:ok, str} -> eval_clause(cls, str, env)
		end
	end
	def eval_expr({:lambda, par, free, seq}, env) do
		case Env.closure(free, env) do
			:error ->
				:error
			closure ->
				{:ok, {:closure, par, seq, closure}}
		end
	end

	def eval_clause([], _, _) do
		:error
	end
	def eval_clause([{:clause, ptr, seq} | cls], str, env) do
		vars = extract_var(ptr)
		env = Env.remove(vars, env)

		case eval_match(ptr, str, env) do
			:fail -> eval_clause(cls, str, env)
			{:ok, env} -> eval_seq(seq, env)
		end
	end
	
	def eval_match(:ignore, str, env) do 
		{:ok, env}
	end
	def eval_match({:atm, id}, str, env) do 
		if id == str do 
			{:ok, env} 
		else 
			:fail
		end
	end
	def eval_match({:var, id}, str, env) do 
		case Env.lookup(id, env) do
			#not bound to anything
			nil -> 
				 {:ok, Env.add(id, str, env)}
			#bound to y or something else and we fail to match
			{_, ^str}-> 
				{:ok, env}
			{_,_} -> 
				:fail
		end
	end
	def eval_match({:cons, first, second}, [str1 | str2], env) do
		case eval_match(first, str1, env) do
			:fail -> :fail
			{:ok, env}->
				eval_match(second, str2, env)
		end
	end
	def eval_match(_,_,_) do
		:fail
	end

	def eval_seq([exp], env) do
		eval_expr(exp, env)
	end
	def eval_seq([{:match, pattern, expr} | rest], env) do
		case eval_expr(expr, env) do
			:error -> :error
			{:ok, str} ->
				vars = extract_var(pattern)
				env = Env.remove(vars, env)

				case eval_match(pattern, str, env) do
					:fail -> 
						:error
					{:ok, env} -> eval_seq(rest, env)
				end
		end
	end
	def extract_var(pattern) do
		extract_var(pattern, [])
	end
	def extract_var(:ignore, vars) do
		vars
	end
	def extract_var({:atm, x}, vars) do
		vars
	end
	def extract_var({:var, x}, vars) do
		[x|vars]
	end
	def extract_var({:cons, first, second}, vars) do
		extract_var(second, extract_var(first, vars))
	end

	def eval(seq) do
		eval_seq(seq, Env.new())
	end

	def test() do
	seq = [{:match, {:var, :x}, {:atm, :a}}, {:case, {:var, :x},[{:clause, {:atm, :b}, [{:atm, :ops}]}, {:clause, {:atm, :a}, [{:atm, :yes}]}]}]		
	eval(seq)
	end
end