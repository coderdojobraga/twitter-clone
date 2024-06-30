defmodule TwitterCloneWeb.PostLive.Index do
  use TwitterCloneWeb, :live_view

  alias TwitterClone.Feed
  alias TwitterClone.Feed.Post

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{}, as: "post")

    {:ok,
     socket
     |> assign(:form, form)
     |> stream(:posts, Feed.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("search", %{"post" => ""}, socket) do
    {:noreply,
     socket
     |> stream(:posts, Feed.list_posts(), reset: true)}
  end

  @impl true
  def handle_event("search", %{"post" => title}, socket) do
    {:noreply,
     socket
     |> stream(:posts, Feed.search_posts(title), reset: true)}
  end

  @impl true
  def handle_info({TwitterCloneWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Feed.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end
end
