#--- Exercise 5 representing a splay tree in elixir
    # Last accessed node is being more easily accessed next time by restructuring
    # the tree

defmodule Splay do

  # tree is empty, just return node with key and value
  def update(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  # case node is already in the root
  def update({:node, key, _, a, b}, key, value) do
    {:node, key, value, a, b}
  end

  # rv and rk is root value and root key, zig case when node us found to the left
  def update({:node, rk, rv, zig, c}, key, value) when key < rk do
    # zig transformation
    {:splay, _, a, b} = splay(zig, key)
    {:node, key, value, a, {:node, rk, rv, b, c}}
  end

  # rv and rk is root value and root key, zag case when node us found to the right
  def update({:node, rk, rv, a, zag}, key, value) when key >= rk do
    # Zag transformation.
    {:splay, _, b, c} = splay(zag, key)
    {:node, key, value, {:node, rk, rv, a, b}, c}
  end

  # node not found, return nil & nil
  defp splay(nil, _) do
    {:splay, :na, nil, nil}
  end

  # node is simply found
  defp splay({:node, key, value, a, b}, key) do
    {:splay, key, a, b}
  end

  # we want to go to left subtree but its empty
  defp splay({:node, rk, rv, nil, b}, key) when key < rk do
    {:splay, :na, nil, {:node, rk, rv, nil, b}}
  end

  # we want to go to right subtree but its empty
  defp splay({:node, rk, rv, a, nil}, key) when key >= rk do
      {:splay, :na, {:node, rk, rv, a, nil}, nil}
  end

  # node is found in left subtree
  defp splay({:node, rk, rv, {:node, key, value, a, b}, c}, key) do
    {:splay, key, c, {:node, rk, rv, a, b}}
  end

  # node is found in right subtree
  defp splay({:node, rk, rv, a, {:node, key, value, b, c}}, key) do
    {:splay, key, {:node, rk, rv, b, c}, a}
  end

  # left-left case, zig-zig
  defp splay({:node, gk, gv, {:node, pk, pv, zig_zig, c}, d}, key) do
    when key < gk and key < pk do
      {:splay, value, a, b} = splay(zig_zig, key)
      {:splay, value, a, {:node, pk, pv, b, {:node, gk, gv, c, d}}}
    end
  end

  # left-right case, zig-zag
  defp splay({:node, gk, gv, {:node, pk, pv, a, zig_zag}, d}, key) do
    when key < gk and key >= pk do
      {:splay, value, b, c} = splay(zig_zag, key)
      {:splay, value, a, {:node, pk, pv, b, {:node, gk, gv, c, d}}}
    end
  end

  # right-right case, zag-zag
  defp splay({:node, gk, gv, {:node, pk, pv, zag_zag, c}, d}, key) do
    when key > gk and key >= pk do
      {:splay, value, c, d} = splay(zag_zag, key)
      {:splay, value, {:node, pk, pv, {:node, gk, gv, a, b}, c}, d}
    end
  end

  # right-left case zag-zig
  defp splay({:node, gk, gv, a, {:node, pk, pv, zag_zig, d}}, key) do
    when key >= gk and key < pk do
    {:splay, value, b, c} = splay(zag_zig, key)
    {:splay, value, {:node, gk, gv, a, b}, {:node, pk, pv, c, d}}
    end
  end


end
