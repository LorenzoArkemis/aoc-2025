defmodule XorSolver do
  def xor_list(list), do: Enum.reduce(list, 0, &Bitwise.bxor(&1, &2))

  def min_subset_xor(target, nums) do
    n = length(nums)

    1..n
    |> Enum.find_value(fn size ->
      nums
      |> combinations(size)
      |> Enum.any?(fn subset -> xor_list(subset) == target end)
      |> if do
        size
      else
        false
      end
    end)
  end

  defp combinations(_, 0), do: [[]]
  defp combinations([], _), do: []

  defp combinations([h | t], k) do
    with_h = for rest <- combinations(t, k - 1), do: [h | rest]
    without_h = combinations(t, k)
    with_h ++ without_h
  end
end

defmodule Parser do
  def to_bitstring(indices) do
    0..Enum.max(indices)
    |> Enum.map(fn i ->
      if i in indices, do: "1", else: "0"
    end)
    # reverse them to xor the integer values
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer(2)
  end

  def buttons_parser(rest) do
    rest
    |> String.split(" {")
    |> Enum.at(0)
    |> then(&Regex.scan(~r/\(([\d,]+)\)/, &1, capture: :all_but_first))
    |> Enum.map(fn [numbers] ->
      numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&to_bitstring/1)
  end

  def goal_parser(goal_str) do
    goal_str
    |> String.graphemes()
    |> Enum.map(fn
      "." -> "0"
      "#" -> "1"
    end)
    # reverse them to xor the integer values
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer(2)
  end

  def initial_parser("[" <> goal_and_rest) do
    [goal_str, rest] =
      goal_and_rest
      |> String.split("] ")

    {goal_parser(goal_str), buttons_parser(rest)}
  end
end

File.stream!("input")
|> Stream.map(&String.trim/1)
|> Enum.map(fn str -> Parser.initial_parser(str) end)
|> Enum.map(fn {target, numbers} -> XorSolver.min_subset_xor(target, numbers) end)
|> Enum.sum()
|> IO.inspect()
