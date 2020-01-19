#-- Exercise 1

defmodule Introduction do
#------- Functions

  # multiplication n * m
  def mul(n, m), do: mul(0, n, m)
  def mul(product, _, 0), do: product
  def mul(product, n, m), do: mul(product + n, n, m-1)

  # n^m
  def exp(n, m), do: exp(1, n, m)
  def exp(res, n, 0), do: res
  def exp(res, n, m), do: exp(mul(res, n), n, m - 1)

  # function nth to find a value nth value in a list
  def nth(n, []), do: "finding element was unsuccessful!"
  def nth(0, [k | rest]), do: k
  def nth(n, [_ | rest]), do: nth(n - 1, rest)

  # function len computes the number of elements in a list
  def len(l), do: len(0, l)
  def len(length, []), do: length
  def len(length, [h | tail]), do: len(length + 1, tail)

  # function len computes the sum of all elements in a list
  def sum(l), do: sum(0, l)
  def sum(s, []), do: s
  def sum(s, [h | t]), do: sum(s + h, t)

  #function duplicate all elements of the array
  def duplicate(l) when is_list(l), do: duplicate([], l)
  def duplicate(dup, []), do: dup
  def duplicate(dup, [h | t]), do: duplicate([h, h | dup], t)

  #function adds an element x to a list if it already does not exist
  def add(x, []), do: [x]
  def add(x, [x | _] = l), do: l
  def add(x, [n | rest]), do: [n | add(x, rest)]

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
    to_integer(t ,n + mul( exp(2, len(t)), rem(h, 2)))
  end

  # fibonacci series
  def fib(1), do: 1
  def fib(0), do: 0
  def fib(n) do
    fib(n-1) + fib(n-2)
  end

  def append([], y), do: y
  def append([h | t], y), do: [h | append(t, y)]


#------- Sorting
  # insertion sort
  def insertion_srt([]), do: []
  def insertion_srt(list) when is_list(list), do: insertion_srt(list, [])

  def insertion_srt([], res) when is_list(res), do: res
  def insertion_srt([h | t], []), do: insertion_srt(t, [h])
  def insertion_srt([c1 | t1], list = [c2 | t2]), do:
    insertion_srt(t1, insert(c1, list))

  # place input element in correct spot such that the list is sorted
  def insert(c1, []), do: [c1]
  def insert(c1, list = [h | t]) when h <= c1, do: [h | insertion_srt(c1, t)]
  def insert(c1, [h | t]), do: [c1, h | t]


  # quick sort
  def quick_srt([]), do: []
  def quick_srt(list = [piv | tail]) when is_list(list), do: partition(piv, tail)

  def partition(piv, []), do: [piv]
  def partition(piv, list = [h | tail]) do
    {lesser, greater} = q_split(piv, list)
    append(quick_srt(lesser), [piv | quick_srt(greater)])
  end

  # returns two lists such that all element in the first one is greater than pivot
  # and lesser that pivot in the other list
  def q_split(p, l) when is_list(l), do: q_split(p, l, [], [])

  def q_split(p, [], lesser, greater), do: {lesser, greater}
  def q_split(p, [h | t], lesser, greater) when p <= h, do:
    q_split(p, t, lesser, [h | greater])
  def q_split(p, [h | t], lesser, greater), do:
    q_split(p, t, [h | lesser], greater)


  # merge sort
  def merge_srt([]), do: []
  def merge_srt([x]), do: [x]
  def merge_srt(list) when is_list(list) do
    {splitted1, splitted2} = split(list)
    merge(merge_srt(splitted1), merge_srt(splitted2))
  end

  # merges two lists
  def merge([], []), do: []
  def merge([], list = [h | t]), do: list
  def merge(list = [h | t], []), do: list
  def merge(list1 = [h1 | t1], list2 = [h2 | t2]) do
    if h1 < h2, do: [h1 | merge(t1, list2)], else: [h2 | merge(list1, t2)]
  end

  # split list in two
  def split(l) when is_list(l), do: split([], [], l)
  def split(l1, l2, []), do: {l1, l2}
  def split(l1, l2, [h | t]) do
    split([h | l2], l1, t)
  end



end
