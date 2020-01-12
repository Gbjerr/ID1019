#--- Exercise 2

defmodule Derivative do
  @type literal() :: {:const, number()} | {:const, atom()}
                  | {:var, atom()}

  @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()}
                | literal()

  def test do
    expr = {:mul, {:mul, {:sin, {:var, :x}}, {:mul, {:const, 5}, {:var, :x}}}, {:mul, {:const, 4}, {:var, :x}}}

    derivative = deriv(expr, :x)

    untangled = untangle(derivative)
    showcase(untangled)
  end

#---------- Derivatives
  # derivative of constants
  def deriv({:const, _}, _), do: {:const, 0}
  # derivative of variables
  def deriv({:var, x}, x), do: {:const, 1}
  def deriv({:var, y}, _), do: {:var, y}
  # derivative taken from a product of two functions depending on same variable x
  def deriv({:mul, e1, e2}, x), do:
    {:add, {:mul, deriv(e1, x), e2}, {:mul, e1, deriv(e2, x)} }
  # derivative taken from a sum of two functions depending on same variable x
  def deriv({:add, e1, e2}, x), do:
    {:add, deriv(e1, x), deriv(e2, x)}
  # derivative of exponential function
  def deriv({:exp, e1, e2 = {:const, c}}, x), do:
    {:mul, e2, {:exp, e1, {:const, c - 1}}}
  #derivative of ln(x)
  def deriv({:ln, e1}, x) do
    case e1  do
      {:const, c} -> {:const, 0}
      {:var, x} ->  {:div, {:const, 1}, e1}
    end
  end
  #derivative of 1/x
  def deriv({:div, {:const, c}, e2}, x), do: {:div, {:const, (-1)*c}, {:exp, x, 2}}
  #derivative of sqrt(x)
  def deriv({:sqrt, {:var, x}}, x), do:
    {:div, {:const, 1}, {:mult, {:const, 2}, {:sqrt, {:var, x}}}}

  def deriv({:sin, {:var, x}}, x), do: {:cos, {:var, x}}


#---------- Simplifying expressions

  def untangle({:var, x}), do: {:var, x}
  def untangle({:const, c}), do: {:const, c}

  # handling division, cosine and sin expressions
  def untangle({:div, e1, e2}), do: {:div, untangle(e1), untangle(e2)}
  def untangle({:cos, e1}), do: {:cos, untangle(e1)}
  def untangle({:sin, e1}), do: {:sin, untangle(e1)}

  # multiplication with zero is always zero, and two constants multiplied is reduced
  # to one constant, that is the product of both.
  def untangle({:mul, a, b}) do
    s1 = untangle(a)
    s2 = untangle(b)
    res = if s1 == {:const, 0} || s2 == {:const, 0} do
            {:const, 0}
          else
            if elem(s1, 0) == :const && elem(s2, 0) == :const do
              {:const, elem(s1, 1) * elem(s2, 1)}
            else
              {:mul, s1, s2}
            end
          end
  end

  # reduces two constants in addition, to one as sum of both. Reduces expressions
  # whether a constant/s zero in addition.
  def untangle({:add, a, b}) do
    s1 = untangle(a)
    s2 = untangle(b)
    res = if !(s1 == {:const, 0} || s2 == {:const, 0}) do
            if elem(s1, 0) == :const && elem(s2, 0) == :const do
              {:const, elem(s1, 1) + elem(s2, 1)}
            else
              {:add, s1, s2}
            end
          else
            if s1 == {:const, 0} && s2 == {:const, 0} do {:const, 0}
            else
              if s1 == {:const, 0} && !(s2 == {:const, 0}) do s2
              else
                if s2 == {:const, 0} && !(s1 == {:const, 0}) do s1
                end
              end
            end
          end
  end

#---------- showcasing expressions
  def showcase({:const, c}), do: "#{c}"
  def showcase({:var, x}), do: "x"
  def showcase({:mul, e1, e2}), do: "#{showcase(e1)} * #{showcase(e2)}"
  def showcase({:add, e1, e2}), do: "#{showcase(e1)} + #{showcase(e2)}"
  def showcase({:div, e1, e2}), do: "#{showcase(e1)} / #{showcase(e2)}"
  def showcase({:cos, e1}), do: "cos(#{showcase(e1)})"
  def showcase({:sin, e1}), do: "sin(#{showcase(e1)})"





end

IO.inspect Derivative.test()
