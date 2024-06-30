defmodule TwitterCloneWeb.Plugs.Redirect do
  @moduledoc """
  A plug that redirects the user to a specified path.
  """
  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(to: opts[:to])
  end
end
