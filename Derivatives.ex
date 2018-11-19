defmodule Derivatives do
	@type literal() :: {:const, number()} | {:const, atom()} | {:var, atom()}
	@type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} | literal()
	@type exponent() :: {:exp, literal(), number()} 
	def deriv({:const,_}, _) do simplify({:const, 0}) end
	def deriv({:var, v}, v) do 
		simplify({:var, 1})
	end
	def deriv({:var,y}, _) do {:const, 0} end
	def deriv({:mul, e1, e2}, v) do 
		simplify({:add, {:mul, deriv(e1, v), e2}, {:mul, deriv(e2, v), e1}})
	end
	def deriv({:add, e1, e2}, v) do 
		simplify({:add, {deriv(e1, v)}, deriv(e2, v)})
	end
	def deriv({:exp, l, n}, v) do
		case l do
		{:const, _} ->
			simplify({:const, 0})
		{:var, _} ->
			simplify({:mul, {:const, n}, {:exp, {:var, v}, {:const, n-1}}})
		end
	end
	def simplify({:const, x}) do
		x
	end
	def simplify({:var, x}) do
		x
	end
	def simplify({:add, e1, e2}) do
		IO.write
	end
	def simplify(x) do
		x 
	end
end