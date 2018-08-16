defmodule GradingService.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias GradingService.Repo
  alias GradingService.User

  schema "users" do
	  field :username, :string
	  field :questions, :integer, default: 0
	  field :correct, :integer, default: 0
	  field :question_handles, :string, default: "0"
  end

  @required_fields ~w(username)

  def insert_user(%{} = user) do
    %User{}
    |> cast(user, @required_fields)
    |> Repo.insert!
  end

  def get_user(user_id) do
    Repo.get!(User, user_id)
  end

  def get_id(username) do
  user =  User |> Repo.get_by(username: username)
  user.id
  end

  def get_question_handle(user_id) do
    user = Repo.get!(User, user_id)
    user.question_handles
  end


def update_questions(user_id) do
   %User{}
   |> changeset()
   |> increment_questions_counter(user_id)
end

def update_correct(user_id) do
   %User{}
   |> changeset()
   |> increment_correct_counter(user_id)
end

def add_question_handle(user_id) do
  user = get_user(user_id)
  User.changeset(user, %{question_handles:  UUID.uuid4()})
  |> Repo.update!
  get_question_handle(user_id)
end

def reset_question_handle(user_id) do
  user = get_user(user_id)
  User.changeset(user, %{question_handles:  "0"})
  |> Repo.update!
end

def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :questions, :correct, :id, :question_handles])
end

defp increment_questions_counter(changeset, user_id) do
    "users"
      |> where([u], u.id == ^user_id)
      |> Repo.update_all(inc: [questions: 1])
    changeset
end

defp increment_correct_counter(changeset, user_id) do
    "users"
      |> where([u], u.id == ^user_id)
      |> Repo.update_all(inc: [correct: 1])
    changeset
end

end
