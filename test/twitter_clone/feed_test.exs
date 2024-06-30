defmodule TwitterClone.FeedTest do
  use TwitterClone.DataCase

  alias TwitterClone.Feed

  describe "posts" do
    alias TwitterClone.Feed.Post

    import TwitterClone.FeedFixtures

    @invalid_attrs %{title: nil, body: nil, username: nil, likes: nil, reposts: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Feed.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Feed.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{
        title: "some title",
        body: "some body",
        username: "some username",
        likes: 42,
        reposts: 42
      }

      assert {:ok, %Post{} = post} = Feed.create_post(valid_attrs)
      assert post.title == "some title"
      assert post.body == "some body"
      assert post.username == "some username"
      assert post.likes == 42
      assert post.reposts == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feed.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        title: "some updated title",
        body: "some updated body",
        username: "some updated username",
        likes: 43,
        reposts: 43
      }

      assert {:ok, %Post{} = post} = Feed.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.body == "some updated body"
      assert post.username == "some updated username"
      assert post.likes == 43
      assert post.reposts == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Feed.update_post(post, @invalid_attrs)
      assert post == Feed.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Feed.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Feed.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Feed.change_post(post)
    end
  end
end
