defmodule TwitterClone do
  @moduledoc """
  TwitterClone keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def schema do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query
      import TwitterCloneWeb.Gettext

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end

  def context do
    quote do
      import Ecto.Query, warn: false

      alias Ecto.Multi
      alias TwitterClone.Repo

      def apply_filters(query, opts) do
        Enum.reduce(opts, query, fn
          {:where, filters}, query ->
            where(query, ^filters)

          {:fields, fields}, query ->
            select(query, [i], map(i, ^fields))

          {:order_by, criteria}, query ->
            order_by(query, ^criteria)

          {:limit, criteria}, query ->
            limit(query, ^criteria)

          {:offset, criteria}, query ->
            offset(query, ^criteria)

          {:preloads, preload}, query ->
            preload(query, ^preload)

          _, query ->
            query
        end)
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
