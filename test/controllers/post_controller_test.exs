defmodule Blog.PostControllerTest do
  use Blog.ConnCase

  alias Blog.Post
  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_post_path(conn, :index, conn.assigns[:user])
    assert html_response(conn, 200) =~ "Listing posts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_post_path(conn, :new, conn.assigns[:user])
    assert html_response(conn, 200) =~ "New post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_post_path(conn, :create, conn.assigns[:user]), post: @valid_attrs
    assert redirected_to(conn) == user_post_path(conn, :index, conn.assigns[:user])
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_post_path(conn, :create, conn.assigns[:user]), post: @invalid_attrs
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = get conn, user_post_path(conn, :show, conn.assigns[:user], post)
    assert html_response(conn, 200) =~ "Show post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_post_path(conn, :show, conn.assigns[:user], -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = get conn, user_post_path(conn, :edit, conn.assigns[:user], post)
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = put conn, user_post_path(conn, :update, conn.assigns[:user], post), post: @valid_attrs
    assert redirected_to(conn) == user_post_path(conn, :show, conn.assigns[:user], post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = put conn, user_post_path(conn, :update, conn.assigns[:user], post), post: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "deletes chosen resource", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = delete conn, user_post_path(conn, :delete, conn.assigns[:user], post)
    assert redirected_to(conn) == user_post_path(conn, :index, conn.assigns[:user])
    refute Repo.get(Post, post.id)
  end
end
