defmodule BinaryTree do

  def member(_, :nil) do :no end
  def member(e, {:leaf, e}) do :yes end
  def member(_, {:leaf, _}) do :no end

  # confirms if a key exists in the tree
  def member(e, {:node, e, _, _}) do :yes end
  def member(e, {:node, v, left, _}) when e < v, do: member(e, left)
  def member(e, {:node, _, _, right}), do: member(e, right)

  # insert functions
  def insert(e, :nil), do: {:leaf, e}
  def insert(e, {:leaf, v}) when e < v, do: {:node, v, {:leaf, e}, :nil}
  def insert(e, {:leaf, v}), do: {:node, v, :nil, {:leaf, e}}
  def insert(e, {:node, v, left, right }) when e < v, do: {:node, v, insert(e, left), right }
  def insert(e, {:node, v, left, right }), do: {:node, v, left, insert(e, right)}

  # deleting key in a leaf, simply return nil
  def delete(e, {:leaf, e}), do: :nil

  # special cases in deletion when right or left sub-tree is nil, simply return
  # the sub-tree that isn't nil
  def delete(e, {:node, e, :nil, right}), do: right
  def delete(e, {:node, e, left, :nil}), do: left

  # deleting node when it has a left and right sub-tree. Find the minimum key
  # in right sub-tree, delete it and return node containing minimum key appended with sub-tree
  # without that key, and the original left subtree
  def delete(e, {:node, e, left, right}) do
    min = find_min(right)
    new_right = delete(min, right)
    {:node, min, left, new_right}
  end

  # key in node is greater than input, search in left sub-tree
  def delete(e, {:node, v, left, right}) when e < v do
    case {:node, v,  delete(e, left),  right} do
      {:node, v, :nil, :nil} -> {:leaf, v}
      updated -> updated
    end
  end
  # key in node is lesser than input, search in left right sub-tree
  def delete(e, {:node, v, left, right}) do
    case {:node, v,  left,  delete(e, right)} do
      {:node, v, :nil, :nil} -> {:leaf, v}
      updated -> updated
    end
  end

  # finds the minimum value in a BST
  def find_min({:leaf, v}), do: {:leaf, v}
  def find_min(:nil), do: :nil
  def find_min({:node, v, left, right}) do
    case find_min(left) do
      :nil ->
        v
      {:leaf, x} ->
        x
      updated ->
        updated
    end
  end


  def test do
              #            21                                     21
              #          /    \                                 /    \
              #        7       28                             7       25
              #      /   \    /  \                          /  \     / \
              #     6    10  23  nil  delete(25, tree)    6    10  23  nil
              #             /  \         ----------->             /  \
              #            22  25                               22  26
              #               /  \                                 / \
              #              24  26                              24  27
              #                 /  \
              #                nil  27

    IO.inspect tree = {:node, v, left, right} = {:node, 21, {:node, 7, {:leaf, 6}, {:leaf, 10}},
    {:node, 28, {:node, 23, {:leaf, 22}, {:node, 25, {:leaf, 24}, {:node, 26, :nil, {:leaf, 27}}}}, :nil}}
    IO.puts "
    member(25, tree) = #{member(25, tree)}"
    IO.puts "
     ----------> delete(25, tree) ---------->
    "
    IO.inspect updated = delete(25, tree)
    IO.puts "
    member(25, updated) = #{member(25, updated)}"
  end
end

BinaryTree.test()
