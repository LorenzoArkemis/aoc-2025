transpose = fn rows ->
  rows
  |> Enum.zip()
  |> Enum.map(&Tuple.to_list/1)
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn line -> Regex.scan(~r/\d+|\*|\+/, line) |> List.flatten() end)
|> then(&transpose.(&1))
|> Enum.map(fn list ->
  {Enum.drop(list, -1), List.last(list)}
  |> then(
    &Enum.reduce(
      elem(&1, 0),
      if elem(&1, 1) == "*" do
        1
      else
        0
      end,
      fn item, acc ->
        case elem(&1, 1) do
          "+" -> acc + String.to_integer(item)
          "*" -> acc * String.to_integer(item)
          _ -> -1
        end
      end
    )
  )
end)
|> Enum.sum()
|> IO.inspect()
