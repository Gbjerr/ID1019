#--- Exercise 3
# Shunting trains where we define a short seqeuence of moves to move wagons from
# three tracks, the main track, track one and track two.
defmodule Trains do

  def test do
    init_state = {main = [:a, :b, :c], first = [], second = []}
    #updated_state = Moves.single({:one, 1}, init_state)
    new_state = Moves.move([{:one, 1}, {:two, 1}, {:two, -1}, {:one, -1}], init_state) 
  end

end

# available moves for shunting trains
defmodule Moves do
  # function handling multiple operations recursively
  def move([], init_state = {main, track_one, track_two}), do: init_state
  def move([h | t], init_state = {main, track_one, track_two}), do:
    move(t, single(h, init_state))

  # zero means do nothing, simply return initial state
  def single({_, 0}, init_state), do: init_state
  def single({_, num}, init_state = {[], track_one, track_two}) when num > 0, do: init_state

  # shunts wagons from main track to track 1
  def single({:one, num}, {main, track_one, track_two}) when num > 0, do:
    {Lists.take(main, length(main) - num), Lists.append(Lists.drop(main, length(main) - num), track_one), track_two}

  # shunts wagons from track 1 to main track
  def single({:one, num}, {main, track_one, track_two}) when num < 0, do:
    {Lists.append(main, Lists.take(track_one, (num * (-1)))), Lists.drop(track_one, num * (-1)), track_two}

  # shunts wagons from main track to track 2
  def single({:two, num}, {main, track_one, track_two}) when num > 0, do:
    {Lists.take(main, length(main) - num), track_one, Lists.append(Lists.drop(main, length(main) - num), track_two)}

  # shunts wagons from track 2 to main track
  def single({:two, num}, {main, track_one, track_two}) when num < 0, do:
    {Lists.append(main, (Lists.take(track_two, (num * (-1))))), track_one, Lists.drop(track_two, num * (-1))}

end

# support module for list operations on trains
defmodule Lists do

  # returns the list containing the first N elements of a list.
  def take([], _), do: []
  def take([h | t], 0), do: []
  def take(list = [h | t], n) when n <= length(list), do: [h] ++ take(t, n - 1)

    # returns the list Xs without its first N elements.
  def drop([], _), do: []
  def drop(list = [h | t], 0) when is_list(list), do: list
  def drop([h | t], n), do: drop(t, n - 1)

  # returns input list with the elements of another list appended.
  def append(list1, list2), do: list1 ++ list2

  # tests whether an elements is contained in a list
  def member([], elem), do: []
  def member([elem | []], elem), do: [elem]
  def member([elem | t], elem), do: [elem]
  def member([h | t], elem), do: member(t, elem)

  # finds and returns at what place in the list a wanted element is at
  def position([], _), do: 0
  def position([elem | t], elem), do: 0
  def position([h | t], elem), do: 1 + position(t, elem)
end


IO.inspect Trains.test()
