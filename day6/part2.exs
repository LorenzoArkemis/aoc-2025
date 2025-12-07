File.stream!("input.txt")
|> Stream.map(&String.replace_suffix(&1, "\n", ""))
|> Enum.map(&String.graphemes/1)
|> Enum.map(&Enum.reverse/1)
|> Enum.zip()
|> Enum.map(&Tuple.to_list/1)
|> Enum.filter(&(not Enum.all?(&1, fn ch -> ch == " " end)))
|> Enum.join()
|> then(&Regex.scan(~r/\d+|[+\-*\/]/, &1))
|> List.flatten()
|> Enum.reduce([0], fn
  "*", acc ->
    [sum | numbers] = acc
    [sum + Enum.reduce(numbers, 1, fn number, acc -> acc * number end)]

  "+", acc ->
    [sum | numbers] = acc
    [sum + Enum.sum(numbers)]

  curr, acc ->
    acc ++ [String.to_integer(curr)]
end)
|> IO.inspect()
