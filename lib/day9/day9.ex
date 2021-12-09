defmodule V2021.Day9 do
  @input_file_part1 "lib/day9/input.txt"
  @input_file_part2 "lib/day9/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> scan_for_low_points()
    |> Enum.reduce(0, fn low_point, acc -> acc + low_point + 1 end)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input_p2()
    |> cluster_all()
    |> clusters_size()
    |> Enum.take(3)
    |> Enum.product()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&(String.to_integer(&1)))
    end)
  end

  def parse_input_p2(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&(input_is_basin(&1)))
    end)
  end

  def input_is_basin("9"), do: false
  def input_is_basin(_), do: true

  # PART 1
  def scan_for_low_points(altitude_matrix) do
    altitude_matrix
    |> Enum.with_index(& {&2, &1})
    |> Enum.reduce([], fn {y, row}, acc ->
      [
        row
        |> Enum.with_index(& {&2, &1})
        |> Enum.reduce([], fn {x, altitude}, row_acc ->
          cond do
            is_low_point(altitude, {x, y}, altitude_matrix) -> [altitude | row_acc]
            true -> row_acc
          end
        end)
        | acc ]
    end)
    |> List.flatten()
  end

  def is_low_point(altitude, {x, y}, altitude_matrix) do
      altitude < get_altitude_for(altitude_matrix, {x, y-1}) &&
      altitude < get_altitude_for(altitude_matrix, {x-1, y}) &&
      altitude < get_altitude_for(altitude_matrix, {x+1, y}) &&
      altitude < get_altitude_for(altitude_matrix, {x, y+1})
  end

  def get_altitude_for(_altitude_matrix, {x, y}) when x < 0 or y < 0, do: 10
  def get_altitude_for(_altitude_matrix, {x, y}) when x > 99 or y > 99, do: 10
  def get_altitude_for(altitude_matrix, {x, y}), do: altitude_matrix |> Enum.at(y) |> Enum.at(x)

  # PART 2
  def cluster_all(initial_matrix) do
    initial_matrix
    |> Enum.with_index(& {&2, &1})
    |> Enum.reduce({initial_matrix, 0}, fn {y, row}, {matrix, cluster} ->
      row
      |> Enum.with_index(& {&2, &1})
      |> Enum.reduce({matrix, cluster}, fn {x, _}, {acc_matrix, acc_cluster} ->
        cluster({acc_matrix, acc_cluster}, {x, y}, 0)
      end)
    end)
  end

  def cluster({matrix, current_cluster}, {x, y}, _) when x < 0 or y < 0 or x > 99 or y > 99, do: { matrix, current_cluster }
  def cluster({matrix, current_cluster}, {x, y} = coords, depth) do
    cond do
      get_altitude_for(matrix, coords) != true ->
        { matrix, current_cluster }
      true ->
        maybe_assign_cluster({matrix, current_cluster}, coords, get_altitude_for(matrix, coords))
        |> cluster({x - 1, y}, depth + 1)
        |> cluster({x + 1, y}, depth + 1)
        |> cluster({x, y - 1}, depth + 1)
        |> cluster({x, y + 1}, depth + 1)
        |> maybe_increase_cluster(depth)
    end
  end

  def maybe_assign_cluster({matrix, cluster}, coords, true), do: {update_matrix(matrix, coords, cluster), cluster}
  def maybe_assign_cluster({matrix, cluster}, _, _), do: {matrix, cluster}

  def update_matrix(matrix, {x, y}, value) do
    List.update_at(matrix, y, fn row ->
      List.replace_at(row, x, value)
    end)
  end

  def maybe_increase_cluster({matrix, cluster}, depth) do
    cond do
      List.flatten(matrix) |> Enum.member?(cluster) && depth == 0 ->  {matrix, cluster + 1}
      true -> {matrix, cluster}
    end
  end

  def clusters_size({matrix, _}) do
    matrix
    |> List.flatten()
    |> Enum.reject(&(Enum.member?([true, false], &1)))
    |> map_sizes()
    |> Enum.map(&(elem(&1, 1)))
  end

  def map_sizes(clusters) do
    clusters
    |> Enum.uniq()
    |> Enum.map(&({&1, Enum.count(clusters, fn elem -> elem == &1 end) }))
    |> Enum.sort(fn {_, size1}, {_, size2} -> size1 > size2 end)
  end
end
