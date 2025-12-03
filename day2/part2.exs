is_invalid_number? = fn n ->
  str = Integer.to_string(n)
  len = String.length(str)

  if len < 2 do
    false
  else
    1..div(len, 2)
    |> Enum.any?(fn group_len ->
      if rem(len, group_len) == 0 do
        sequence_a = String.slice(str, 0, group_len)

        repeat_count = div(len, group_len)

        total_str = String.duplicate(sequence_a, repeat_count)

        reconstructed_str == str
      else
        false
      end
    end)
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
|> Enum.sum()
|> IO.inspect()
