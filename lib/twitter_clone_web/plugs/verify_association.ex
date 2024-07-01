defmodule TwitterCloneWeb.Plugs.VerifyAssociation do
  @moduledoc """
  This plug is used to confirm if the object being accessed has an association with the current user.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, fun) when is_map_key(conn.params, "id") do
    case fun.(conn.params["id"]) do
      nil ->
        not_found(conn)

      entity ->
        verify_association(conn, entity)
    end
  end

  def call(conn, _), do: conn

  defp verify_association(conn, entity) do
    if has_relation?(conn, entity) do
      conn
    else
      not_found(conn)
    end
  end

  defp has_relation?(conn, _) when not is_map_key(conn.assigns, :current_user) do
    false
  end

  defp has_relation?(conn, entity) do
    entity.user_id == conn.assigns.current_user.id
  end

  defp not_found(conn) do
    conn
    |> send_resp(:not_found, "")
    |> halt()
  end
end
