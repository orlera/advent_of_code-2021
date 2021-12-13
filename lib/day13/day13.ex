defmodule V2021.Day13 do
  @input_file_part1 "lib/day13/input.txt"
  @input_file_part2 "lib/day13/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> fold_once()
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> fold_all()
    |> Enum.uniq()
    |> plot()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n\n")
    |> List.to_tuple()
    |> extract_points()
  end

  def extract_points({points_list, fold_list}) do
    {
      points_list
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, ",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end),
      fold_list
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.trim(line, "fold along ")
        |> String.split("=")
        |> List.to_tuple()
        |> normalize_fold()
      end)
    }
  end

  def normalize_fold({axis, position}), do: {axis, String.to_integer(position)}

  # PART 1
  def fold_once({points, folds}) do
    folds
    |> List.first()
    |> fold(points)
  end

  def fold({"x", position}, points), do: fold_x(position, points)
  def fold({"y", position}, points), do: fold_y(position, points)

  def fold_x(position, points), do: Enum.map(points, &(fold_x_point(&1, position)))
  def fold_y(position, points), do: Enum.map(points, &(fold_y_point(&1, position)))

  def fold_x_point({x, _} = point, position) when x < position, do: point
  def fold_x_point({x, y}, position), do: {position * 2 - x, y}

  def fold_y_point({_, y} = point, position) when y < position, do: point
  def fold_y_point({x, y}, position), do: {x, position * 2 - y}

  # PART 2
  def fold_all({points, folds}), do: Enum.reduce(folds, points, &fold/2)

  def plot(points) do
   {max_x, max_y} = find_vertex(points)
   List.duplicate("o", max_x + 1)
   |> List.duplicate(max_y + 1)
   |> mark_points(points)
   |> Enum.map(&Enum.join/1)
  end

  def mark_points(matrix, points) do
    matrix
    |> Enum.with_index(& {&2, &1})
    |> Enum.map(fn {y, row} ->
      row
      |> Enum.with_index(& {&2, &1})
      |> Enum.map(fn {x, _} ->
        cond do
          Enum.member?(points, {x, y}) -> "x"
          true -> "."
        end
      end)
    end)
  end

  def find_vertex(points) do
    {
      Enum.max(points, fn {x1, _}, {x2, _} -> x1 >= x2 end) |> elem(0),
      Enum.max(points, fn {_, y1}, {_, y2} -> y1 >= y2 end) |> elem(1)
    }
  end
 end
