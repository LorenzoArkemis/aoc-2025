start_time = System.monotonic_time(:millisecond)

File.stream!("input")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.graphemes/1)
|> Stream.reject(&Enum.all?(&1, fn ch -> ch == "." end))
|> Stream.map(&Enum.with_index/1)
|> Enum.map(fn row ->
  Enum.filter(row, fn {ch, _} -> ch in ["S", "^"] end)
  |> Enum.map(fn {_, index} -> index end)
end)
|> then(fn [head | tail] ->
  Enum.reduce(tail, %{Enum.at(head, 0) => 1}, fn curr_split_indexes, prev_frequencies ->
    split_set = MapSet.new(curr_split_indexes)

    Enum.reduce(prev_frequencies, prev_frequencies, fn {index, value}, new_freq ->
      if MapSet.member?(split_set, index) do
        new_freq
        |> Map.update(index, 0, fn _ -> 0 end)
        |> Map.update(index - 1, value, fn curr_freq -> curr_freq + value end)
        |> Map.update(index + 1, value, fn curr_freq -> curr_freq + value end)
      else
        new_freq
      end
    end)
  end)
end)
|> Map.values()
|> Enum.sum()
|> IO.inspect()

end_time = System.monotonic_time(:millisecond)
IO.puts("Execution time: #{end_time - start_time}ms")
