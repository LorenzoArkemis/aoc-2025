get_squared_dist = fn {x1, y1, z1}, {x2, y2, z2} ->
  (x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2
end

all_pairs = fn points ->
  for i <- 0..(length(points) - 2),
      j <- (i + 1)..(length(points) - 1) do
    {get_squared_dist.(Enum.at(points, i), Enum.at(points, j)), i, j}
  end
end

indexes =
  File.stream!("input")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, ","))
  |> Stream.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
  |> Enum.map(&List.to_tuple/1)
  |> then(&all_pairs.(&1))
  |> Enum.sort_by(&elem(&1, 0))
  |> Enum.reduce_while({%{}, 0}, fn
    {_dist, first, second}, {acc, counter} ->
      key_for_first =
        Enum.find_value(acc, fn {index, connected} ->
          if first in connected, do: index
        end)

      key_for_second =
        Enum.find_value(acc, fn {index, connected} ->
          if second in connected, do: index
        end)

      case {key_for_first, key_for_second} do
        {nil, nil} ->
          {:cont, {Map.put(acc, counter, [first, second]), counter + 1}}

        {key, nil} ->
          if length(acc[key]) == 999 do
            {:halt, {first, second}}
          else
            {:cont, {Map.update(acc, key, [], fn list -> list ++ [second] end), counter}}
          end

        {nil, key} ->
          if length(acc[key]) == 999 do
            {:halt, {first, second}}
          else
            {:cont, {Map.update(acc, key, [], fn list -> list ++ [first] end), counter}}
          end

        {first_key, first_key} ->
          {:cont, {acc, counter}}

        {first_key, second_key} ->
          merged = Enum.uniq(acc[first_key] ++ acc[second_key])

          if length(merged) == 1000 do
            {:halt, {first, second}}
          else
            {:cont,
             {acc
              |> Map.put(first_key, merged)
              |> Map.delete(second_key), counter}}
          end
      end
  end)
  |> IO.inspect()

File.stream!("input")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.split(&1, ","))
|> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
|> then(&(Enum.at(Enum.at(&1, elem(indexes, 0)), 0) * Enum.at(Enum.at(&1, elem(indexes, 1)), 0)))
|> IO.inspect()
