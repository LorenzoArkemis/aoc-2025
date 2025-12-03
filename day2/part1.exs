is_invalid_number? = fn n ->
  Integer.to_string(n)
  |> String.length()
  |> (&(rem(&1, 2) == 0))
  |> cond

  if is_even_length do
    div(len, 2)
    |> then(&String.split_at(str, &1))
    |> then(&(elem(&1, 0) == elem(&1, 1)))
  else
    false
  end
end

find_numbers = fn range ->
  for number <- range, is_invalid_number?.(number) do
    number
  end
end

File.stream!("input1")
|> Stream.map(&String.trim/1)
|> Stream.map(fn line ->
  line
  |> String.split(",")
  |> Enum.map(fn part ->
    String.split(part, "-")
  end)
  |> Enum.flat_map(fn [a, b] ->
    String.to_integer(a)..String.to_integer(b)
  end)
end)
|> Enum.flat_map(&find_numbers.(&1))
|> Enum.reduce(0, fn n, acc -> acc + n end)
|> IO.inspect()
