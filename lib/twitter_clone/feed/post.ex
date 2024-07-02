defmodule TwitterClone.Feed.Post do
  use TwitterClone, :schema

  alias TwitterClone.Accounts.User
  alias TwitterClone.Feed.{Like, Repost}

  @required_fields ~w(title body user_id)a
  @optional_fields ~w(like_count repost_count)a

  schema "posts" do
    field :title, :string
    field :body, :string

    field :like_count, :integer, default: 0
    field :repost_count, :integer, default: 0

    belongs_to :user, User

    has_many :likes, Like
    has_many :reposts, Repost

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:body, min: 2, max: 250)
  end

  def preloads, do: [:user, :likes, :reposts]
end
