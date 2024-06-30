defmodule TwitterClone.Repo.Seeds.Feed do
  @moduledoc """
  Seeds the database with feed-related data.
  """
  alias TwitterClone.Repo
  alias TwitterClone.Feed
  alias TwitterClone.Feed.Post

  def run do
    case Repo.all(Post) do
      [] ->
        seed_posts()

      _ ->
        Mix.shell().error("Found existing posts, skipping seeding.")
    end
  end

  defp seed_posts do
    for i <- 1..50 do
      %{
        "title" => "Post #{i}",
        "body" => Faker.Lorem.paragraph(),
        "username" => Faker.Internet.user_name(),
      }
      |> Feed.create_post()
    end
  end
end

TwitterClone.Repo.Seeds.Feed.run()
