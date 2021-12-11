defmodule V2021.Day11 do
  @input_file_part1 "lib/day11/input.txt"
  @input_file_part2 "lib/day11/input.txt"
  @flashed 9999
  @already_flashed 1111
  @grid_size 9

  def solution_part1() do
    grid =
      @input_file_part1
      |> parse_input()
    {grid, 0}
    |> step(1)
    |> elem(1)
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
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # PART 1

  def step(octopus_info, 101), do: octopus_info
  def step(octopus_info, step) do
    octopus_info
    |> gain_energy()
    |> flash()
    |> step(step + 1)
  end

  def gain_energy({octopus_grid, flashes_num}) do
    {
      octopus_grid
      |> Enum.map(fn line ->
        Enum.map(line, fn octopus -> octopus + 1 end)
      end),
      flashes_num
    }
  end

  def flash({octopus_grid, _} = octopus_info) do
    cond do
      needs_flaring(octopus_grid) -> do_flash(octopus_info)
      true ->
        octopus_info |> reset_flashed_octopuses()
    end
  end

  def needs_flaring(octopus_grid) do
    octopus_grid
    |> List.flatten()
    |> Enum.any?(&(&1 > 9 && &1 != @flashed && &1 != @already_flashed))
  end

  def do_flash(octopus_info) do
    octopus_info
    |> set_as_flashed()
    |> gain_flash_energy()
    |> set_as_already_flashed()
    |> flash()
  end

  def gain_flash_energy({octopus_grid, flashes_num}) do
    {
      octopus_grid
      |> Enum.with_index(& {&2, &1})
      |> Enum.map(fn {y, line} ->
        line
        |> Enum.with_index(& {&2, &1})
        |> Enum.map(fn {x, octopus} ->
          sum_flashed_energy_for(octopus_grid, octopus, x, y)
        end)
      end),
      flashes_num
    }
  end

  def reset_flashed_octopuses({octopus_grid, flashes_num}) do
    {
      Enum.map(octopus_grid, fn line ->
        Enum.map(line, &maybe_reset/1)
      end),
      flashes_num + (List.flatten(octopus_grid) |> Enum.count(&(&1 == @already_flashed)))
    }
  end

  def set_as_flashed({octopus_grid, flashes_num}) do
    {
      Enum.map(octopus_grid, fn line ->
        Enum.map(line, &maybe_set_as_flashed/1)
      end),
      flashes_num
    }
  end

  def set_as_already_flashed({octopus_grid, flashes_num}) do
    {
      Enum.map(octopus_grid, fn line ->
        Enum.map(line, &maybe_set_as_already_flashed/1)
      end),
      flashes_num
    }
  end

  def maybe_reset(@already_flashed), do: 0
  def maybe_reset(octopus), do: octopus

  def maybe_set_as_flashed(octopus) when octopus > 9 and octopus != @already_flashed, do: @flashed
  def maybe_set_as_flashed(octopus), do: octopus

  def maybe_set_as_already_flashed(octopus) when octopus == @flashed, do: @already_flashed
  def maybe_set_as_already_flashed(octopus), do: octopus

  def sum_flashed_energy_for(_, octopus, _, _) when octopus == @flashed or octopus == @already_flashed, do: octopus
  def sum_flashed_energy_for(octopus_grid, octopus, x, y) do
    octopus +
    flashed_energy_for(octopus_grid, x-1, y-1) +
    flashed_energy_for(octopus_grid, x, y-1) +
    flashed_energy_for(octopus_grid, x+1, y-1) +
    flashed_energy_for(octopus_grid, x-1, y) +
    flashed_energy_for(octopus_grid, x+1, y) +
    flashed_energy_for(octopus_grid, x-1, y+1) +
    flashed_energy_for(octopus_grid, x, y+1) +
    flashed_energy_for(octopus_grid, x+1, y+1)
  end

  def flashed_energy_for(_, x, y) when x < 0 or y < 0 or x > @grid_size or y > @grid_size, do: 0
  def flashed_energy_for(octopus_grid, x, y) do
    cond do
      octopus_at(octopus_grid, x, y) == @flashed -> 1
      true -> 0
    end
  end

  def octopus_at(grid, x, y), do: Enum.at(grid, y) |> Enum.at(x)
end
