defmodule ExpiryDates do
  def get_ranges(range) do
    String.split(range, "-", parts: 2)
    |> then(&(String.to_integer(Enum.at(&1, 0))..String.to_integer(Enum.at(&1, 1))))
  end

  def total_covered(ranges) do
    Enum.reduce(ranges, 0, fn first..last//_step, acc ->
      acc + (last - first + 1)
    end)
  end
end

File.stream!("input")
|> Stream.map(&String.trim/1)
|> Stream.take_while(&(&1 != ""))
|> Enum.map(&ExpiryDates.get_ranges/1)
|> Enum.sort_by(fn first.._ -> first end)
|> Enum.reduce([], fn range, acc ->
  case acc do
    [] ->
      [range]

    [prev_first..prev_last | rest] ->
      curr_first..curr_last = range

      if curr_first > prev_last + 1 do
        [range | acc]
      else
        merged = prev_first..max(prev_last, curr_last)
        [merged | rest]
      end
  end
end)
|> ExpiryDates.total_covered()
|> IO.inspect()
