defmodule V2021.Day10 do
  @input_file_part1 "lib/day10/input.txt"
  @input_file_part2 "lib/day10/input.txt"
  @opening_chars ["(", "[", "{", "<"]
  @correspondence_map %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }
  @score_map_p1 %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }
  @score_map_p2 %{
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> find_corrupt_lines()
    |> compute_score()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> find_corrupt_lines()
    |> Enum.filter(fn {corrupt_char, _} -> corrupt_char == "" end)
    |> flip_openings()
    |> compute_scores_p2()
    |> middle_score()
    |> IO.inspect()
  end

  # INPUT PARSING
  def parse_input(input) do
    input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  # PART 1
  def find_corrupt_lines(lines) do
    Enum.map(lines, &(find_corrupt_char(&1, [])))
  end

  def find_corrupt_char([], openings), do: {"", openings}
  def find_corrupt_char([char | rest], []) do
    cond do
      Enum.member?(@opening_chars, char) -> find_corrupt_char(rest, [char])
      true -> {char, {}}
    end
  end
  def find_corrupt_char([char | rest], [last_opening | other_openings] = openings) do
    cond do
      Enum.member?(@opening_chars, char) -> find_corrupt_char(rest, [char | openings])
      corresponds(char, last_opening) -> find_corrupt_char(rest, other_openings)
      true -> {char, openings}
    end
  end

  def corresponds(closing, opening), do: Map.get(@correspondence_map, opening) == closing

  def compute_score(corrupted_chars) do
    corrupted_chars
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&score_for/1)
    |> Enum.sum()
  end

  def score_for(char, map \\ @score_map_p1), do: Map.get(map, char)

  # PART 2
  def flip_openings(openings_list) do
    openings_list
    |> Enum.map(fn {_, openings} ->
      Enum.map(openings, &(Map.get(@correspondence_map, &1)))
    end)
  end

  def compute_scores_p2(closings_list) do
    Enum.map(closings_list, fn closings ->
      Enum.reduce(closings, 0, fn closing, acc ->
        acc * 5 + score_for(closing, @score_map_p2)
      end)
    end)
  end

  def middle_score(scores) do
    scores
    |> Enum.sort()
    |> Enum.at(Enum.count(scores) |> div(2))
  end
end
