defmodule TwitterClone.Repo.Seeds.Feed do
  @moduledoc """
  Seeds the database with feed-related data.
  """
  alias TwitterClone.Repo
  alias TwitterClone.Feed
  alias TwitterClone.Feed.Post
  alias TwitterClone.Accounts.User

  def run do
    case Repo.all(Post) do
      [] ->
        seed_posts()

      _ ->
        Mix.shell().error("Found existing posts, skipping seeding.")
    end
  end

  defp seed_posts do
    users = Repo.all(User)

    for i <- 1..50 do
      %{
        "title" => "Post #{i}",
        "body" => Faker.Lorem.paragraph(),
        "user_id" => Enum.random(users).id
      }
      |> Feed.create_post()
    end
  end
end

TwitterClone.Repo.Seeds.Feed.run()
