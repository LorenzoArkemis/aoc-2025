File.stream!("input1")
|> Stream.map(&String.trim/1)
|> Enum.map(fn
  "R" <> rest ->
    String.to_integer(rest)
    |> (fn num -> {div(num, 100), rem(num, 100)} end).()

  "L" <> rest ->
    String.to_integer(rest)
    |> (fn num -> {div(num, 100), -rem(num, 100)} end).()
end)
|> Enum.reduce({50, 0}, fn {rot, val}, {curr, sum} ->
  next = curr + val

  cond do
    curr == 0 and next < 0 -> 0
    next not in 0..99 -> 1
    rem(next, 100) == 0 -> 1
    true -> 0
  end

  {Integer.mod(next, 100), sum + pass + rot}
end)
|> IO.inspect()
