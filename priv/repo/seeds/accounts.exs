defmodule TwitterClone.Repo.Seeds.Accounts do
  @moduledoc """
  Seeds the database with accounts-related data.
  """
  alias TwitterClone.Repo
  alias TwitterClone.Accounts
  alias TwitterClone.Accounts.User

  def run do
    case Repo.all(User) do
      [] ->
        seed_users()

      _ ->
        Mix.shell().error("Found existing users, skipping seeding.")
    end
  end

  defp seed_users do
    data = gather_data()

    for line <- data do
      email = build_email(line)
      username = build_username(email)

      %{
        "email" => email,
        "username" => username,
        "password" => "password1234"
      }
      |> Accounts.register_user()
    end
  end

  defp build_email(user) do
    user
    |> String.downcase()
    |> String.replace(~r/\s*/, "") # Remove all whitespaces
    |> String.normalize(:nfd)
    |> String.replace(~r/[^a-z0-9]/, "") # Remove all non-alphanumeric characters
    |> Kernel.<>("@coderdojobraga.org")
  end

  defp build_username(email) do
    email
    |> String.split("@")
    |> List.first()
  end

  defp gather_data do
    "priv/fake/users.txt"
    |> File.read!()
    |> String.split("\n")
  end
end

TwitterClone.Repo.Seeds.Accounts.run()
