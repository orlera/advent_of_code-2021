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
    |> build_cave_graph()
    |> count_paths_p2_for("start", MapSet.new(), false)
    |> IO.inspect()
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
      true -> visit_and_iterate(map, source, visited, source)
    end
  end

  # PART 2
  def count_paths_p2_for(_, "end", _, _), do: 1
  def count_paths_p2_for(map, source, visited, small) do
    case small && MapSet.member?(visited, source) do
      true ->
        case MapSet.member?(visited, :second_visit) do
          true -> 0
          false -> visit_and_iterate(map, source, visited, :second_visit, &count_paths_p2_for/4)
        end
      false -> visit_and_iterate(map, source, visited, source, &count_paths_p2_for/4)
    end
  end

  def visit_and_iterate(map, source, visited_list, last_visited, iter_fun \\ &count_paths_for/4) do
    map
    |> Map.get(source)
    |> Enum.map(fn target -> iter_fun.(map, target, MapSet.put(visited_list, last_visited), Regex.match?(~r/[a-z]/, target)) end)
    |> Enum.sum()
  end
end
