#--- Exercise 4
# Implementation of a 2-3 tree, with tuples represented as nodes, and type of node
# defined by atoms that is either :leaf, :two or :three

# Rules: Apart from leaf nodes, nodes can either have one key and two children,
#        or two keys and three children, where children from left -- right is
#        ordered by key smallest to greatest

defmodule TwoThree do

  def test do
    insert(17, :zzz, {:three, 2, 5, {:two, 2, {:leaf, 2, :yyy}, {:leaf, 5, :www}},
      {:two, 5, {:leaf, 5, :ooo}, {:leaf, 6, :lll}}, {:three, 13, 16, {:leaf, 13, :fff}, {:leaf, 16, :hhh}, {:leaf, 18, :vvv}}})
  end


  def insert(key, value, root) do
    case insertf(key, value, root) do
      {:four, q1, q2, q3, t1, t2, t3, t4} ->
        {:two, q2, {:two, q1, t1, t2}, {:two, q3, t3, t4}}
      updated ->
        updated
    end
  end

  # empty, simply insert leaf
  def insertf(key, value, nil), do: {:leaf, key, value}

  # encountering only one leaf, insert makes it two
  def insertf(k, v, {:leaf, k1, _} = l) do
    cond do
      k <= k1 ->
        {:two, k, {:leaf, k, v}, l}
      true ->
        {:two, k1, l, {:leaf, k, v}}
    end
  end

  # encountering node with two children, insert makes it three
  def insertf(k, v, {:two, k1, {:leaf, k1, _} = l1,
                               {:leaf, k2, _} = l2}) do
    cond do
      k <= k1 ->
        {:three, k, k1, {:leaf, k, v}, l1, l2}
      k <= k2 ->
        {:three, k1, k, l1, {:leaf, k, v}, l2}
      true ->
        {:three, k1, k2, l1, l2, {:leaf, k, v}}
    end
  end

  # encountering node with three children, insert makes it temporarily four. Making it four
  # children does not fulfill rules of 2-3 tree, but is included for detection to change later on.
  def insertf(k, v, {:three, k1, k2, {:leaf, k1, _} = l1, {:leaf, k2, _} = l2,
                                                          {:leaf, k3, _} = l3}) do
    cond do
      k <= k1 ->
        {:four, k, k1, k2, {:leaf, k, v}, l1, l2, l3}
      k <= k2 ->
        {:four, k1, k, k2, l1, {:leaf, k, v}, l2, l3}
      k <= k3 ->
        {:four, k1, k2, k, l1, l2, {:leaf, k, v}, l3}
      true ->
        {:four, k1, k2, k3, l1, l2, l3, {:leaf, k, v}}
    end
  end

  # encountering node with left and right sub-tree, check if greater or lesser than key.
  # either way, if insertion becomes sub-tree with four children, correct and make it a tuple
  # with three children to fulfill 2-3 tree rules
  def insertf(k, v, {:two, k1, left, right}) do
    # if root key is greater than input key, do insert in left subtree, if else, do
    # right subtree
    cond do
      k <= k1 ->
        case insertf(k, v, left) do
          {:four, q1, q2, q3, t1, t2, t3, t4} ->
            {:three, q2, k1, {:two, q1, t1, t2}, {:two, q3, t3, t4}, right}
          updated ->
            {:two, k1, updated, right}
        end
      true ->
        case insertf(k, v, right) do
          {:four, q1, q2, q3, t1, t2, t3, t4} ->
            {:three, k1, q2, left , {:two, q1, t1, t2}, {:two, q3, t3, t4}}
          updated ->
            {:two, k1, left, updated}
        end
      end
  end

  # encountering node with three subtrees, handle an eventual four node when inserting
  def insertf(k, v, {:three, k1, k2, left, middle, right}) do
    cond do
      k <= k1 ->
        case insertf(k, v, left) do
          {:four, q1, q2, q3, t1, t2, t3, t4} ->
            {:four, q2, k1, k2, {:two, q1, t1, t2}, {:two, q3, t3, t4}, middle, right}
          updated ->
            {:three, k1, k2, updated, middle, right}
        end
      k <= k2 ->
        case insertf(k, v, middle) do
          {:four, q1, q2, q3, t1, t2, t3, t4} ->
            {:four, k1, q2, k2, left, {:two, q1, t1, t2}, {:two, q3, t3, t4}, right}
          updated ->
            {:three, k1, k2, left, updated, right}
        end
      true ->
        case insertf(k, v, right) do
          {:four, q1, q2, q3, t1, t2, t3, t4} ->
            {:four, k1, k2, q2, left, middle, {:two, q1, t1, t2}, {:two, q3, t3, t4}}
          updated ->
            {:three, k1, k2, left, middle, updated}
        end
    end
  end

end

IO.inspect TwoThree.test()
