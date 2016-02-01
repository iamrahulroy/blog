defmodule Blog.SessionControllerTest do
  use Blog.ConnCase
  alias Blog.User

  setup do
    User.changeset(%User{}, %{username: "test", password: "test", password_confirmation: "test", email: "test@example.com"})
    |> Repo.insert
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows the login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates a new user session for a valid user", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "test", password: "test"}
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Sign in successful!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create session with an invalid login", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "test", password: "badPassword"}
    refute get_session(conn, :current_user)
    assert get_flash(conn, :error) == "Invalid username/password combination!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create session if user does not exist", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "foo", password: "bar"}
    assert get_flash(conn, :error) == "Invalid username/password combination!"
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
