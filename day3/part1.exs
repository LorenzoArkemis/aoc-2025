check_to_second_to_last = fn {list, last} ->
  String.graphemes(list)
  |> Enum.reduce({"0", "0"}, fn char, {first, second} ->
    cond do
      char > first -> {char, "0"}
      char > second -> {first, char}
      true -> {first, second}
    end
  end)
  |> then(fn {first, second} ->
    {first, max(second, last)}
  end)
  |> Tuple.to_list()
  |> Enum.join()
end

File.stream!("input1")
|> Stream.map(&String.trim/1)
|> Enum.map(fn row ->
  String.split_at(row, -1)
  |> check_to_second_to_last.()
end)
|> Enum.sum_by(&String.to_integer/1)
|> IO.inspect()
