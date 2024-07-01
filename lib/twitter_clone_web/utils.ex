defmodule TwitterCloneWeb.Utils do
  @moduledoc """
  Utility functions for rendering data on views.
  """
  alias Timex.Format.DateTime.Formatters.Relative

  @doc """
  Returns a relative datetime string for the given datetime.
  """
  def relative_datetime(datetime) do
    Relative.lformat!(datetime, "{relative}", Gettext.get_locale(TwitterCloneWeb.Gettext))
  end
end
