defmodule TwitterClone.Feed.Like do
  use TwitterClone, :schema

  alias TwitterClone.Accounts.User
  alias TwitterClone.Feed.Post

  @required_fields ~w(user_id post_id)a

  schema "likes" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:user_id, :post_id], name: :unique_likes)
    |> prepare_changes(&increment_post_likes/1)
  end

  defp increment_post_likes(changeset) do
    if post_id = get_change(changeset, :post_id) do
      query = from Post, where: [id: ^post_id]
      changeset.repo.update_all(query, inc: [like_count: 1])
    end

    changeset
  end
end
