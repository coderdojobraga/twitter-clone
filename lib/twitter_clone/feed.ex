defmodule TwitterClone.Feed do
  @moduledoc """
  The Feed context.
  """
  use TwitterClone, :context

  alias TwitterClone.Accounts.User
  alias TwitterClone.Feed.{Post, Like, Repost}

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

      iex> list_posts(order_by: [desc: :inserted_at])
      [%Post{}, ...]

  """
  def list_posts(opts \\ []) do
    Post
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Returns the list of posts that match the given title.

  ## Examples

      iex> search_posts("title")
      [%Post{}, ...]

  """
  def search_posts(title, opts) do
    Post
    |> where([p], ilike(p.title, ^"%#{title}%"))
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id, preloads \\ []) do
    Post
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def with_default_post_preloads(%Post{} = post) do
    post
    |> Repo.preload(Post.preloads())
  end

  @doc """
  Likes a post.

  ## Examples

      iex> like_post(post, user)
      %Post{}

  """
  def like_post(%Post{} = post, %User{} = user) do
    %Like{}
    |> Like.changeset(%{post_id: post.id, user_id: user.id})
    |> Repo.insert!()

    get_post!(post.id, Post.preloads())
  end

  @doc """
  Unlikes a post.

  ## Examples

      iex> unlike_post(post, user)
      %Post{}

  """
  def unlike_post(%Post{} = post, %User{} = user) do
    like = get_like!(post, user)

    Multi.new()
    |> Multi.delete(:like, like)
    |> Multi.update(:post, Post.changeset(post, %{like_count: post.like_count - 1}))
    |> Repo.transaction()

    get_post!(post.id, Post.preloads())
  end

  @doc """
  Gets a like.

  Raises `Ecto.NoResultsError` if the Like does not exist.

  ## Examples

      iex> get_like!(post, user)
      %Like{}

      iex> get_like!(post, user)
      ** (Ecto.NoResultsError)

  """
  def get_like!(%Post{} = post, %User{} = user) do
    Like
    |> where([l], l.post_id == ^post.id and l.user_id == ^user.id)
    |> Repo.one!()
  end

  @doc """
  Reposts a post.

  ## Examples

      iex> repost_post(post, user)
      %Post{}

  """
  def repost_post(%Post{} = post, %User{} = user) do
    # TODO: For simplicity, a repost do not create an actual new record
    # You can implement it, anyways :eyes:

    %Repost{}
    |> Repost.changeset(%{post_id: post.id, user_id: user.id})
    |> Repo.insert!()

    get_post!(post.id, Post.preloads())
  end

  @doc """
  Unreposts a post.

  ## Examples

      iex> unrepost_post(post, user)
      %Post{}

  """
  def unrepost_post(%Post{} = post, %User{} = user) do
    repost = get_repost!(post, user)

    Multi.new()
    |> Multi.delete(:repost, repost)
    |> Multi.update(:post, Post.changeset(post, %{repost_count: post.repost_count - 1}))
    |> Repo.transaction()

    get_post!(post.id, Post.preloads())
  end

  @doc """
  Gets a repost.

  Raises `Ecto.NoResultsError` if the Repost does not exist.

  ## Examples

      iex> get_repost!(post, user)
      %Repost{}

      iex> get_repost!(post, user)
      ** (Ecto.NoResultsError)

  """
  def get_repost!(%Post{} = post, %User{} = user) do
    Repost
    |> where([r], r.post_id == ^post.id and r.user_id == ^user.id)
    |> Repo.one!()
  end
end
