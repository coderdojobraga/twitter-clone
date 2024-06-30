defmodule TwitterClone.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :body, :text
      add :username, :string
      add :likes, :integer
      add :reposts, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
