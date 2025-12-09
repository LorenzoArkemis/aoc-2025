get_squared_dist = fn {x1, y1, z1}, {x2, y2, z2} ->
  :math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2)
end

all_pairs = fn points ->
  for i <- 0..(length(points) - 2),
      j <- (i + 1)..(length(points) - 1) do
    {get_squared_dist.(Enum.at(points, i), Enum.at(points, j)), i, j}
  end
end

File.stream!("input")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.split(&1, ","))
|> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
|> Enum.map(&List.to_tuple/1)
|> then(&all_pairs.(&1))
|> Enum.sort_by(&elem(&1, 0))
|> Enum.take(1000)
|> Enum.reduce({%{}, 0}, fn
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
        {Map.put(acc, counter, [first, second]), counter + 1}

      {key, nil} ->
        {Map.update(acc, key, [], fn list -> list ++ [second] end), counter}

      {nil, key} ->
        {Map.update(acc, key, [], fn list -> list ++ [first] end), counter}

      {first_key, first_key} ->
        {acc, counter}

      {first_key, second_key} ->
        merged = Enum.uniq(acc[first_key] ++ acc[second_key])

        {acc
         |> Map.put(first_key, merged)
         |> Map.delete(second_key), counter}
    end
end)
|> then(&Enum.map(elem(&1, 0), fn {_k, v} -> length(v) end))
|> Enum.sort(:desc)
|> Enum.take(3)
|> Enum.reduce(1, fn el, acc ->
  el * acc
end)
|> IO.inspect()
