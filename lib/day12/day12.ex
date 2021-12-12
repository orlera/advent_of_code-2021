defmodule V2021.Day12 do
  @input_file_part1 "lib/day12/input.txt"
  @input_file_part2 "lib/day12/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> build_cave_graph()
    |> count_paths_for("start", MapSet.new(), false)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split("-", trim: true)
      |> List.to_tuple()
    end)
  end

  def build_cave_graph(paths), do: Enum.reduce(paths, %{}, &add_path_to_graph/2)

  def add_path_to_graph({source, "start"}, map), do: Map.update(map, "start", [source], &([source | &1]))
  def add_path_to_graph({"start", target}, map), do: Map.update(map, "start", [target], &([target | &1]))
  def add_path_to_graph({"end", target}, map), do: Map.update(map, target, ["end"], &(["end" | &1]))
  def add_path_to_graph({source, "end"}, map), do: Map.update(map, source, ["end"], &(["end" | &1]))
  def add_path_to_graph({source, target}, map) do
    map
    |> Map.update(source, [target], &([target | &1]))
    |> Map.update(target, [source], &([source | &1]))
  end

  # PART 1
  def count_paths_for(_, "end", _, _), do: 1
  def count_paths_for(map, source, visited, small) do
    cond do
      small && MapSet.member?(visited, source) -> 0
      true ->
        map
        |> Map.get(source)
        |> Enum.map(fn target -> count_paths_for(map, target, MapSet.put(visited, source), Regex.match?(~r/[a-z]/, target)) end)
        |> Enum.sum()
    end
  end
end
