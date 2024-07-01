defmodule TwitterCloneWeb.PostLive.Components.Post do
  use TwitterCloneWeb, :live_component

  alias TwitterClone.Feed
  alias TwitterClone.Feed.Post

  attr :post, Post, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative">
      <.link
        href={~p"/posts/#{@post}"}
        class="block w-full rounded-lg border border-gray-200 bg-white px-6 py-4 shadow hover:bg-gray-50"
      >
        <div class="flex gap-3">
          <div class="grid gap-3">
            <div class="grid gap-0.5">
              <h2 class="text-sm font-medium leading-snug text-gray-900">
                @<%= @post.user.username %>
                <span class="text-gray-500">added a new post</span>
              </h2>
              <h3 class="text-xs font-normal leading-4 text-gray-500">
                <%= relative_datetime(@post.inserted_at) %>
              </h3>
            </div>
          </div>
        </div>

        <div class="mt-3.5 mb-7">
          <h3 class="text-lg font-medium leading-snug text-gray-900"><%= @post.title %></h3>
          <p class="text-xs font-normal leading-4 text-gray-500"><%= @post.body %></p>
        </div>
      </.link>

      <div class="left-[22px] absolute bottom-3 mt-6 flex gap-3">
        <button
          phx-click="like"
          disabled={!@current_user}
          phx-target={@myself}
          class={[
            @current_user && "hover:text-green-500",
            !@current_user && "cursor-not-allowed",
            "flex gap-1 items-center text-xs font-medium leading-4 text-gray-600",
            current_user_liked?(@current_user, @post) && "text-green-500 hover:text-green-800"
          ]}
        >
          <.icon name="hero-hand-thumb-up" class="size-5" />
          <span><%= @post.like_count %></span>
        </button>

        <button
          disabled={!@current_user}
          class={[
            @current_user && "hover:text-amber-500",
            !@current_user && "cursor-not-allowed",
            "flex gap-1 items-center text-xs font-medium leading-4 text-gray-600"
          ]}
        >
          <.icon name="hero-arrow-path-rounded-square" class="size-5" />
          <span><%= @post.repost_count %></span>
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("like", _, socket) do
    user = socket.assigns.current_user
    post = socket.assigns.post

    if current_user_liked?(user, post) do
      unlike_post(socket, post, user)
    else
      like_post(socket, post, user)
    end
  end

  defp like_post(socket, post, user) do
    post = Feed.like_post(post, user)
    {:noreply, assign(socket, post: post)}
  end

  defp unlike_post(socket, post, user) do
    post = Feed.unlike_post(post, user)
    {:noreply, assign(socket, post: post)}
  end

  defp current_user_liked?(user, post) do
    post.likes
    |> Enum.any?(&(&1.user_id == user.id))
  end
end
