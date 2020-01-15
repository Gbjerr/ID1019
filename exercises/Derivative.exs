#--- Exercise 2

defmodule Derivative do
  @type literal() :: {:const, number()} | {:const, atom()}
                  | {:var, atom()}

  @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()}
                | literal()

  def test do
    expr = {:add, {:add, {:const, 0}, {:div, {:var, :x}}}, {:mul, {:ln, {:var, :x}}, {:sin, {:var, :x}}}}
    IO.puts "f(x) = #{showcase((untangle(expr)))}"

    IO.puts "f'(x) = #{showcase(untangle(deriv(expr, :x)))}"
  end

#---------- Derivatives
  # derivative of constants
  def deriv({:const, _s}, x), do: {:const, 0}
  # derivative of variables
  def deriv({:var, x}, x), do: {:const, 1}
  def deriv({:var, y}, _), do: {:var, y}
  # derivative taken from a product of two functions depending on same variable x
  def deriv({:mul, e1, e2}, x), do: {:add, {:mul, deriv(e1, x), e2}, {:mul, e1, deriv(e2, x)} }
  # derivative taken from a sum of two functions depending on same variable x
  def deriv({:add, e1, e2}, x), do: {:add, deriv(e1, x), deriv(e2, x)}

  def deriv({:sub, e1, e2}, x), do: {:sub, deriv(e1, x), deriv(e2, x)}
  # derivative of exponential function
  def deriv({:exp, {:var, x}, {:const, c}}, x), do: {:mul, {:const, c}, {:exp, {:var, x}, {:const, c - 1}}}

  #derivative of ln(x)
  def deriv({:ln, e1}, x) do
    case e1 do
      {:const, c} -> {:const, 0}
      {:var, x} ->  {:div, e1}
    end
  end

  # derivative 1/x
  def deriv({:div, {:var, x}}, x), do: {:mul, {:const, -1}, {:div, {:exp, {:var, x}, {:const, 2}}}}
  #derivative of sqrt(x)
  def deriv({:sqrt, {:var, x}}, x), do: {:div, {:const, 1}, {:mul, {:const, 2}, {:sqrt, {:var, x}}}}

  def deriv({:sin, e1}, x), do: {:mul, deriv(e1, x), {:cos, {:var, x}}}
  def deriv({:cos, e1}, x), do: {:mul, {:mul, deriv(e1, x), {:const, -1}}, {:sin, e1}}


#---------- Simplifying expressions

  def untangle({:var, x}), do: {:var, x}
  def untangle({:const, c}), do: {:const, c}

  def untangle({:exp, e1, e2}) do
    s1 = untangle(e1)
    s2 = untangle(e2)
    if elem(s1, 0) == :var && s2 == {:const, 1} do
      s1
    else
      {:exp, s1, s2}
    end
  end

  def untangle({:div, e1}) do
    s1 = untangle(e1)
    if s1 == {:const, 0} do
      {:const, 0}
    else
      {:div, s1}
    end
  end

  def untangle({:ln, e1}), do: {:ln, untangle(e1)}
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
              {:mul, untangle(s1), untangle(s2)}
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

  # same principle as untangling addition
  def untangle({:sub, a, b}) do
    s1 = untangle(a)
    s2 = untangle(b)
    res = if (elem(s1, 0) == :const || elem(s2, 0) == :const) do
            if elem(s1, 0) == :const && elem(s2, 0) == :const do
              {:const, elem(s1, 1) - elem(s2, 1)}
            end
          else
              if s1 == {:const, 0} && !(s2 == {:const, 0}) do untangle(s2)
              else
                if s2 == {:const, 0} && !(s1 == {:const, 0}), do: untangle(s1)
              end
          end
  end

#---------- showcasing expressions
  def showcase({:const, c}), do: "#{c}"
  def showcase({:var, x}), do: "x"
  def showcase({:mul, e1, e2}), do: "#{showcase(e1)} * #{showcase(e2)}"
  def showcase({:add, e1, e2}), do: "(#{showcase(e1)} + #{showcase(e2)})"
  def showcase({:div, e1}), do: "1 / #{showcase(e1)}"
  def showcase({:ln, e1}), do: "ln(#{showcase(e1)})"
  def showcase({:cos, e1}), do: "cos(#{showcase(e1)})"
  def showcase({:sin, e1}), do: "sin(#{showcase(e1)})"
  def showcase({:exp, e1, e2}), do: "#{showcase(e1)}^#{showcase(e2)}"





end

IO.inspect Derivative.test()
