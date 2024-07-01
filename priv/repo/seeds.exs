defmodule TwitterClone.Repo.Seeds do
  @moduledoc """
  Script for seeding the database with initial data.

  This script is executed by running `mix ecto.seed`.
  """

  @seeds_dir "priv/repo/seeds"

  def run do
    ["accounts.exs", "feed.exs"]
    |> Enum.each(&Code.require_file(Path.join(@seeds_dir, &1)))
  end
end

TwitterClone.Repo.Seeds.run()
