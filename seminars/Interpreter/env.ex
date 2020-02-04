#--- Following module is our environment which contains the types of
#    our interpretator

defmodule Env do

  @type key :: atom()
  @type str :: any()
  @type key_pair :: {key, str}

  @type atm :: atom()
  @type env :: [{key, str}]

  @spec new() :: []
  def new do
    []
  end

  @spec add(key, str, env) :: env
  def add(key, str, env) do
    [{key, str} | env]
  end

  @spec lookup(key, env) :: key_pair | nil
  def lookup(key, []), do: nil
  def lookup(key, [pair = {key, _} | rest]), do: pair
  def lookup(key, [foo = {other, _} | rest]), do: lookup(key, rest)

  @spec remove([key], env) :: env
  def remove(_, []), do: []
  def remove([], list), do: list
  def remove([key | rest], list) do
    new_list = remove_occurrs(key, list)
    remove(rest, new_list)
  end

  @spec remove_occurrs(key, env) :: env
  def remove_occurrs(key, []), do: []
  def remove_occurrs(key, [pair = {key, _} | rest]), do:
    remove_occurrs(key, rest)
  def remove_occurrs(key, [pair = {_not_this, _} | rest]), do:
    [pair | remove_occurrs(key, rest)]


end


#IO.inspect Env.lookup(:hello, Env.add(:hello, 44, Env.new()))
