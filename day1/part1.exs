parse_direction = fn
  "R" <> value -> String.to_integer(value)
  "L" <> value -> -String.to_integer(value)
end

is_zero? = fn
  0 -> 1
  _ -> 0
end

File.stream!("input1")
|> Stream.map(&String.trim/1)
|> Stream.map(parse_direction)
|> Enum.reduce({0, 50}, fn val, {zeros, curr_pointer} ->
  Integer.mod(curr_pointer + val, 100)
  |> (&{zeros + is_zero?.(&1), &1}).()
end)
|> IO.inspect()
