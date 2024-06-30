defmodule TwitterClone.FeedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TwitterClone.Feed` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        likes: 42,
        reposts: 42,
        title: "some title",
        username: "some username"
      })
      |> TwitterClone.Feed.create_post()

    post
  end
end
