defmodule GradingService.User do
  use Ecto.Schema

  import Ecto.Changeset
  #import Ecto.Query, only: [from: 2]

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

  #ostali su za update

  #   def update_note(%{"id" => note_id} = note_changes) do
  #   Repo.get!(Note, note_id)
  #   |> cast(note_changes, @required_fields, @optional_fields)
  #   |> Repo.update!
  # end

  def update_questions(%{"id" => user_id} = user_changes) do
  	Repo.get!(User, user_id)
  	|> cast(user_changes, @required_fields)
  	|> prepare_changes(fn changeset ->
    assoc(changeset.data, :user)
    |> changeset.repo.update_all(inc: [questions: 1])
    changeset
  end)
  	#|> update_change(:questions, 2) #ovo nosta ne radi
  	 #|> Repo.update!
#  	  	|> update_change(:questions, &(&1 + 1))

  end



# def create_comment(comment, params) do
#   comment
#   |> cast(params, [:body, :post_id])
#   |> prepare_changes(fn changeset ->
#     assoc(changeset.data, :post)
#     |> changeset.repo.update_all(inc: [comment_count: 1])
#     changeset
#   end)
# end




