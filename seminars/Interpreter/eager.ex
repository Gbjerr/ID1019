#--- Following module interprets what kind of expressions we can do
#    and we can represent them
end

defmodule Eager do

  @type atm :: {:atm, any()}
  @type variable :: {:var, any()}

  @type ignore :: :ignore

  @type cons(e) :: {:cons, e, e}

  @type str :: any()
  @type env :: [{variable, str}]

  @type match :: {:match, pattern, expr}

  @type expr :: variable | atm | :ignore | expr | cons(expr)
  @type pattern :: variable | atm | :ignore | expr | cons(expr)
  @type seq :: [expr] | [match | seq]

  @spec eval_expr(expr, env) :: {:ok, str} | :error
  def eval_expr({:atm, str}, _), do: {:ok, str}

  def eval_expr({:var, str}, env) do
    case Env.lookup(str, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  def eval_expr({:cons, he, te}, env) do
    case eval_expr(he, env) do
      :error ->
        :error
      {:ok, hs} ->
        case eval_expr(te, env) do
          :error ->
            :error
          {:ok, ts} ->
            {:ok, [hs, ts]}
        end
    end
  end

  @spec eval_match(pattern, str, env) :: {:ok, env} | :fail
  def eval_match(:ignore, _, env) do
    {:ok, []}
  end

  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end

  def eval_match({:var, id}, str, env) do
    IO.puts "line 52"
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end

  def eval_match({:cons, hp, tp}, [hq, tq], env) do
    IO.puts "line 64"
    case eval_match(hp, hq, env) do
      :fail ->
          :fail
      {:ok, env} ->
        eval_match(tp, tq, env)
    end
  end

  def eval_match( _,_,_) do
    :fail
  end

  # initialize the an empty environment and initialize evaluation
  def eval(seq) do
    eval_seq(seq, Env.new())
  end

  # evaluate the sequence of expressions
  @spec eval_seq([expr], env) :: {:ok, str} | :error
  def eval_seq([exp], env) do eval_expr(exp, env) end
  def eval_seq([{:match, pattern, exp} | rest], env) do
    case eval_expr(exp, env) do
      :error ->
        :error
      {:ok, str} ->
        vars = extract_vars(pattern)
        env = Env.remove(vars, env)

        case eval_match(pattern, str, env) do
          :fail ->
            :error
          {:ok, env} ->
            eval_seq(rest, env)
        end
    end
  end

  # Take a pattern and return list of variables
  @spec extract_vars(pattern) :: [variable] | []
  def extract_vars({:cons, p1, p2}) do extract_vars(p1) ++ extract_vars(p2) end
  def extract_vars({:var, var}) do [var] end
  def extract_vars(_) do [] end



end
