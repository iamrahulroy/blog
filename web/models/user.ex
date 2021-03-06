defmodule Blog.User do
  use Blog.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_digest, :string

    timestamps

    # Virtual Fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :posts, Blog.Post
  end


  @required_fields ~w(username email password password_confirmation)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> hash_password
  end


  def gravatar(email) do
    "http://www.gravatar.com/avatar/" <> md5(email)
  end

  defp md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest, hashpwsalt(password))
    else
      changeset
    end
  end
end
