defmodule Huffman do
	def sample do
		'the quick brown fox jumps over the lazy dog
	     this is a sample text that we will use when we build 
	     up a table we will only handle lower case letters and
	     no punctuation symbols the frequency will of course not 
	     represent english but it is probably not that far off'
 	end
	def text() do
		'this is something that we should encode'
	end

	def test do 
		sample = sample()
		tree = tree(sample)
		# encode = encode_table(tree)
		# decode = decode_table(tree)
		# text = text()
		# seq = encode(text, encode)
		# decode(seq, decode)
	end

	def tree(sample) do
		freq = freq(sample)
		huffman(freq)
	end

	def encode_table(tree) do
		
	end

	def decode_table(tree) do
		
	end

	def encode(text, table) do
		
	end

	def decode(seq, tree) do
		
	end

	def freq(sample) do
		freq(sample, [])
	end
	def freq([], freqlist) do
		isort(freqlist)
	end
	def freq([char | rest], freqlist) do 
		case contains(char, freqlist) do
			false -> 
				var = {char, getfreq(char, rest) + 1}
				freq(rest, freqlist ++ [var])
			_ -> 
				freq(rest, freqlist)
		end
	end

	def getfreq(char, []) do
		0
	end
	def getfreq(char, [head | tail]) do
		if char == head do
			1 + getfreq(char, tail)
		else
			0 + getfreq(char, tail)
		end
	end

	def contains(char, []) do
		false
	end
	def contains(char, [{headChar, _} | tail]) do
		if char == headChar do
			true
		else
			contains(char, tail)
		end
	end
	
	def huffman([{x,_}]) do
		x
	end
	def huffman([{_, freq} = {x, y}, {_, hFreq} = {a, b}| tail]) do
		new = {{x, a}, y + b} 
		newList = insert(new, tail)
		huffman(newList)
	end

	def isort(l) do
		isort(l,[])
	end
	def isort([], l) do
		l
	end
	def isort([head | tail], sorted) do
		isort(tail, insert(head, sorted))
	end
	def insert({a, af}, []) do [{a, af}] end
    def insert({a, af}, [{b, bf} | rest]) when af < bf do
        [{a, af}, {b, bf} | rest]
    end
    def insert({a, af}, [{b, bf} | rest]) do
        [{b, bf} | insert({a, af}, rest)]
    end
	# def insert({A,Af}, []) do 
 #    	[{A,Af}]
	# end
	# def insert({A,Af}, [{B,Bf}|Rest]) when Af < Bf do
 #    	[{A,Af}, {B,Bf} | Rest]
 #    end
	# def insert({A,Af}, [{B,Bf}|Rest]) do
 #    [{B,Bf} | insert({A,Af}, Rest)]
	# end
end
