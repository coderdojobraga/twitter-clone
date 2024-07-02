defmodule TwitterClone.Feed.Repost do
  use TwitterClone, :schema

  alias TwitterClone.Accounts.User
  alias TwitterClone.Feed.Post

  @required_fields ~w(user_id post_id)a

  schema "reposts" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(repost, attrs) do
    repost
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:user_id, :post_id], name: :unique_repost)
    |> prepare_changes(&increment_post_reposts/1)
  end

  defp increment_post_reposts(changeset) do
    if post_id = get_change(changeset, :post_id) do
      query = from Post, where: [id: ^post_id]
      changeset.repo.update_all(query, inc: [repost_count: 1])
    end

    changeset
  end
end
