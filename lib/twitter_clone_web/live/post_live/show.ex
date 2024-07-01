defmodule TwitterCloneWeb.PostLive.Show do
  use TwitterCloneWeb, :live_view

  alias TwitterClone.Feed
  alias TwitterClone.Feed.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Feed.get_post!(id, Post.preloads()))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Feed.get_post!(id)
    {:ok, _} = Feed.delete_post(post)

    {:noreply,
     socket
     |> put_flash(:info, "Post deleted successfully")
     |> push_navigate(to: ~p"/posts")}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
