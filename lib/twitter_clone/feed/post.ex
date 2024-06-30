defmodule TwitterClone.Feed.Post do
  use TwitterClone, :schema

  @required_fields ~w(title body)a
  @optional_fields ~w(username likes reposts)a

  schema "posts" do
    field :title, :string
    field :body, :string
    field :username, :string, default: "ruilopesm"
    field :likes, :integer, default: 0
    field :reposts, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:body, min: 2, max: 250)
  end
end
