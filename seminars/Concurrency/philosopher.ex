defmodule Philosopher do

  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, r, l, name, ctrl) do
    spawn_link(fn -> new_philosopher(hunger, r, l, name, ctrl) end)
  end

  def new_philosopher(hunger, r, l, name, ctrl) do
    think_a_bit(hunger, r, l, name, ctrl)
  end

  def think_a_bit(0 ,_left, _right, name, ctrl) do
    IO.puts("#{name} is satisfied!")
  end
  def think_a_bit(hunger, r, l, name, ctrl) do
    IO.puts "Philosopher #{name} is thinking..."
    sleep(1000)
    wait_a_bit(hunger, r, l, name, ctrl)
  end

  def wait_a_bit(hunger, r, l, name, ctrl) do
    IO.puts "Philosopher #{name} is waiting..."
    case Chopstick.request(l, 50) do
      :ok ->
        sleep(200)
        IO.puts "#{name} finds one chopstick at left hand side!"
        case Chopstick.request(r, 50) do
          :ok ->
            IO.puts "#{name} finds two chopsticks beside him and proceeds to eat!"
            eat_some(hunger, r, l, name, ctrl)
          :no ->
            Chopstick.return(r)
            wait_a_bit(hunger, r, l, name, ctrl)
        end
      :no ->
        Chopstick.return(l)
        wait_a_bit(hunger, r, l, name, ctrl)
    end
  end

  def eat_some(hunger, r, l, name, ctrl) do
    IO.puts "#{name} is eating.."
    sleep(50)
    Chopstick.return(l)
    Chopstick.return(r)
    IO.puts "#{name} returns both chopsticks"
    think_a_bit(hunger - 1, r, l, name, ctrl)
  end
end
