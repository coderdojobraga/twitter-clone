defmodule TwitterClone.Feed.Post do
  use TwitterClone, :schema

  alias TwitterClone.Accounts.User

  @required_fields ~w(title body user_id)a
  @optional_fields ~w(likes reposts)a

  schema "posts" do
    field :title, :string
    field :body, :string
    field :likes, :integer, default: 0
    field :reposts, :integer, default: 0

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:body, min: 2, max: 250)
  end

  def preloads, do: [:user]
end
