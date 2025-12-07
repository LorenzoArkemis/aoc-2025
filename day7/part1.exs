File.stream!("test")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.graphemes/1)
|> Stream.filter(
  &(not Enum.all?(&1, fn ch ->
      ch == "."
    end))
)
|> Stream.map(&Enum.with_index/1)
|> Enum.map(&Enum.filter(&1, fn ch -> elem(ch, 0) == "S" or elem(ch, 0) == "^" end))
|> then(fn [h | t] -> {h, t} end)
|> then(
  &Enum.reduce(elem(&1, 1), {elem(&1, 0), 0}, fn curr_splits, {prev_beams, count} ->
    IO.inspect({prev_beams, count})
    curr_split_indexes = Enum.map(curr_splits, fn {_, index} -> index end)

    Enum.reduce(prev_beams, {[], count}, fn
      {_, index}, {acc, c} ->
        if index in curr_split_indexes do
          {Enum.uniq(acc ++ [{"|", index - 1}, {"|", index + 1}]), c + 1}
        else
          {acc ++ [{"|", index}], c}
        end
    end)
  end)
)
|> IO.inspect()
