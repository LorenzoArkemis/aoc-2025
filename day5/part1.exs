defmodule ExpiryDates do
  def get_range_and_expiry_date(item, {ranges, days}) do
    case String.split(item, "-", parts: 2) do
      [from, to] ->
        {ranges ++ [String.to_integer(from)..String.to_integer(to)], days}

      [n] ->
        {ranges, days ++ [String.to_integer(n)]}
    end
  end

  def is_fresh?(day, ranges) do
    Enum.any?(ranges, fn range ->
      day in range
    end)
  end
end

File.stream!("input")
|> Stream.map(&String.trim/1)
|> Stream.reject(&(&1 == ""))
|> Enum.reduce({[], []}, &ExpiryDates.get_range_and_expiry_date/2)
|> then(&Enum.count(elem(&1, 1), fn day -> ExpiryDates.is_fresh?(day, elem(&1, 0)) end))
|> IO.inspect()
