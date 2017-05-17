defmodule Erastosthenes do

  def sieve(prime, next, last?) do
    receive do
      n when rem(n, prime) == 0 ->
        sieve(prime, next, last?)
      n ->
        send next, n
        next = if last? do
          # 自身が最後の篩だったら次の篩を生成する
          {pid, _} = spawn_monitor Erastosthenes, :sieve, [n, next, true] 
          pid
        else
          next
        end
        sieve(prime, next, false)
    end
  end

  def output do
    receive do
      n ->
        IO.puts "#{n} is prime."
        output()
    end
  end
end

opid = spawn Erastosthenes, :output, []
{spid, _} = spawn_monitor Erastosthenes, :sieve, [2, opid, true]

2..100
|> Stream.map(&(send spid, &1))
|> Enum.to_list
