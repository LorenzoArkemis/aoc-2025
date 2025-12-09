File.stream!("input")
|> Stream.map(&String.trim/1)
|> Enum.map(&String.split(&1, ","))
|> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
|> then(
  &for {pi, i} <- Enum.with_index(&1), {pj, j} <- Enum.with_index(&1), i < j, do: {pi, pj, i, j}
)
|> Enum.map(fn {[x1, y1], [x2, y2], i, j} ->
  {(abs(x2 - x1) + 1) * (abs(y2 - y1) + 1), i, j}
end)
|> Enum.max(fn {area_1, _i, _j}, {area_2, _i2, _j2} -> area_1 > area_2 end)
|> IO.inspect()
