#-- Exercise 1

defmodule Introduction do
#------- Functions
  def mult(_, 0) do 0 end
  def mult(n, m) do
    n + mult(n, m - 1)
  end

  def exp(n, 0) do 1 end
  def exp(n, 1) do n end
  def exp(n, m) do
    mult(n, exp(n, m - 1 ))
  end
  # function nth to find a value nth value in a list
  def nth(n, []), do: IO.puts  "#{n}th element was not found!"
  def nth(0, [k | rest])do
    k
  end
  def nth(n, [k | rest]) do
    nth(n - 1, rest)
  end

  # function len computes the number of elements in a list
  def len([]), do: 0
  def len([n | tail]) do
    1 + len(tail)
  end

  # function len computes the sum of all elements in a list
  def sum([]), do: 0
  def sum([h | t]) do
    h + sum(t)
  end

  #function double all values of the array
  def duplicate([]) do [] end
  def duplicate([h | t]) do
    dbl_val = fn(x) -> x * 2 end
    [dbl_val.(h) | duplicate(t)]
  end

  #function adds an element x to a list if it already does not exist
  def add(x, []), do: [x]
  def add(x, [x | rest]), do: [x | rest]
  def add(x, [n | rest]) do [n | add(x, rest)] end

  #function removes all occurrences of x in a list
  def remove(x, []), do: []
  def remove(x, [x | rest]), do: remove(x, rest)
  def remove(x, [n | rest]) do
    [n | remove(x, rest)]
  end

  #function returns the unique elements of a list
  def unique([]), do: []
  def unique([h | t]) do
    [h | unique(remove(h, t))]
  end

  #function returns list containing list of equal elements, not beautiful
  def pack(list) when is_list(list) do
    unique = unique(list)
    getAll(unique, list)
  end

  #function returns all occurences from a list based on unique elements in
  #another list
  def getAll([], list), do: []
  def getAll([first | rest], list) do
    [return_occurences(first, list) | getAll(rest, list)]
  end

  #function returns all occurences of a elemnt from a list
  def return_occurences(x, []), do: []
  def return_occurences(x, [x | t]) do
    [x | return_occurences(x, t)]
  end
  def return_occurences(x, [h | t]) do return_occurences(x, t) end

  #function reverses list
  def reverse([h | []]), do: [h]
  def reverse([h | t]) do
    reverse(t) ++ [h]
  end

  #function converts integer to binary representation
  def to_binary(0) do [] end
  def to_binary(n) do
    to_binary(div(n, 2)) ++ [rem(n, 2)]
  end

  def to_integer(x) do to_integer(x, 0) end
  def to_integer([], n) do n end
  def to_integer([h | t], n) do
    to_integer(t , n + mult( exp(2, len(t)), rem(h, 2)))
  end

  def fib(1) do 1 end
  def fib(0) do 1 end
  def fib(n) do
    fib(n-1) + fib(n-2)
  end


#------- Sorting
  # insertion sort
  def insertion_srt([]), do: []
  def insertion_srt(list) when is_list(list), do: insertion_srt(list, [])

  def insertion_srt([], res) when is_list(res), do: res
  def insertion_srt([h | t], []), do: insertion_srt(t, [h])
  def insertion_srt([c1 | t1], list = [c2 | t2]), do:
    insertion_srt(t1, insertion_srt(c1, list))

  # loops through sorted list and finds spot for input element
  def insertion_srt(c1, []), do: [c1]
  def insertion_srt(c1, list = [h | t]) do
    if c1 == h || h < c1 do
      [h] ++ insertion_srt(c1, t)
    else
      [c1, h | t]
    end
  end

  # quick sort
  def quick_srt([]), do: []
  def quick_srt(list = [piv | tail]) when is_list(list), do: partition(piv, tail)

  def partition(piv, []), do: [piv]
  def partition(piv, list = [h | tail]), do:
    quick_srt(get_lesser(piv, list)) ++ [piv] ++ quick_srt(get_greater(piv, list))
  # support function for quicksort, retrieves list of elments lesser than pivot
  def get_lesser(piv, []), do: []
  def get_lesser(piv, [h | t]), do:
    res = (if h < piv, do: [h], else: []) ++ get_lesser(piv, t)
  # support function for quicksort, retrieves list of elments greater than pivot
  def get_greater(piv, []), do: []
  def get_greater(piv, [h | t]), do:
    res = (if h >= piv, do: [h], else: []) ++ get_greater(piv, t)




  # merge sort
  def merge_srt([]), do: []
  def merge_srt([x]), do: [x]
  def merge_srt(list) when is_list(list) do
    {splitted1, splitted2} = Enum.split(list, div(length(list), 2))
    merge(merge_srt(splitted1), merge_srt(splitted2))
  end

  # merges two lists
  def merge([], []), do: []
  def merge([], list = [h | t]), do: list
  def merge(list = [h | t], []), do: list
  def merge(list1 = [h1 | t1], list2 = [h2 | t2]) do
    if h1 < h2, do: [h1] ++ merge(t1, list2), else: [h2] ++ merge(list1, t2)
  end



end



#IO.puts Intro.mult(3, 4)
#IO.puts Intro.exp(3, 4)
#IO.puts Intro.nth(0, [2, 5, 1])
#length = Intro.len([2, 5, 1, 1])
#IO.puts "length of list is #{length}"
#sum = Intro.sum([2, 5, 1, 1])
#IO.puts "sum of all elements in list: #{sum}"
#IO.inspect Intro.duplicate([2, 5, 1, 1])
#IO.inspect Intro.add(6, [2, 5, 1, 1])
#IO.inspect Intro.remove(2, [2, 5, 1s, 1])
#IO.inspect Intro.unique([:a, :b, :a, :Sd, :a, :b, :b, :a])
#IO.inspect Intro.pack([:a, :a, :b, :c, :b, :a, :c])
#IO.inspect Intro.reverse([:a, :a, :b, :c, :b, :a, :c])
#IO.inspect Intro.to_binary(5)
#IO.puts Introduction.to_integer([1, 0, 1])
#IO.puts Introduction.fib(7)
#IO.inspect Introduction.insertion_srt([7, 0, 6, 7, 4, 2, 8, 5, 6])
#IO.inspect Introduction.quick_srt([7, 0, 6, 7, 4, 2, 8, 5, 6])
IO.inspect Introduction.merge_srt([7, 0, 6, 7, 4, 2, 8, 5, 6])
#IO.inspect Introduction.get_lesser(5, [7, 0, 6, 7, 4, 2, 8, 5, 6])
#IO.inspect Introduction.get_greater(5, [7, 0, 6, 7, 4, 2, 8, 5, 6])
