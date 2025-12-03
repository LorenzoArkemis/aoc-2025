defmodule Digits do
  def get_max_digit(rem_list, rem_digits), do: get_max_digit(rem_list, rem_digits, "")

  def get_max_digit(_rem_list, 0, prev_max), do: prev_max

  def get_max_digit(rem_list, rem_digits, prev_max) do
    Enum.split(rem_list, -rem_digits + 1)
    |> then(fn
      {[], right} -> right
      {left, _} -> left
    end)
    |> Enum.max()
    |> then(&{Enum.find_index(rem_list, fn x -> x == &1 end), &1})
    |> then(&{Enum.slice(rem_list, (elem(&1, 0) + 1)..length(rem_list)), elem(&1, 1)})
    |> then(&get_max_digit(elem(&1, 0), rem_digits - 1, prev_max <> elem(&1, 1)))
  end
end

File.stream!("input1")
|> Stream.map(&String.trim/1)
|> Enum.map(fn row ->
  String.graphemes(row)
  |> then(&Digits.get_max_digit(&1, 12, ""))
end)
|> Enum.map(&String.to_integer/1)
|> Enum.sum()
|> IO.inspect()
