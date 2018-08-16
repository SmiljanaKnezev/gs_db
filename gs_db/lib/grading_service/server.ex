defmodule GradingService.Server do

    alias GradingService.User

  def register(username) do
     User.insert_user(%{username: username})
     User.get_id(username)
  end

  def get_question(user_id) do
    User.update_questions(user_id)
     q_handle = User.add_question_handle(user_id)
    {{:question, List.first(Map.keys(generate_question()))}, {:question_handle, q_handle}}
  end

  def answer_question(user_handle, question_handle, question, answer) do 
    if(check_question_handle?(user_handle, question_handle)) do
      if check_answer(question, answer) do
       User.update_correct(user_handle)
       User.reset_question_handle(user_handle)
        "The answer is correct"
      else
        "Sorry, wrong answer"
      end
   end
  end

  def get_statistics(user_id) do
    user = GradingService.User.get_user(user_id)
    user.username <> ", questions: " <> Integer.to_string(user.questions) <> ", correct: " <> Integer.to_string(user.correct)
  end

  defp check_question_handle?(user_handle, question_handle) do
   String.equivalent?(User.get_question_handle(user_handle) , question_handle)
  end


  defp check_answer(question, answer) do
    generate_questions_map()
    |> Enum.find(fn {_key, val} -> String.equivalent?(List.first(Map.keys(val)), question) end)
    |> Tuple.to_list()
    |> List.last()
    |> Map.values()
    |> Enum.member?(answer)
  end

  defp generate_questions_map() do
    %{ 1 => %{"2 + 2 = ?" => 4},
    2 => %{"10 - 5 = ?" => 5},
    3 => %{"5 + 6 = ?" => 11},
    4 => %{"2 + 28 = ?" => 30},
    5 => %{"11 - 7 = ?" => 4},
    6 => %{"19 - 6 = ?" => 3},
    7 => %{"14 + 5 = ?" => 19},
    8 => %{"20 - 2 = ?" => 18},
    9 => %{"5 + 5 = ?" => 10},
    10 => %{"13 - 3 = ?" => 10},
   11 => %{"9 + 9 = ?" => 18}
  }
  end

  defp generate_question() do
    Map.get(generate_questions_map(), Enum.random(1..11))
  end

  def cant_get_question?(user_handle) do
    has_unanswered_question?(user_handle)
  end

  defp has_unanswered_question?(user_handle) do
     !String.equivalent?(User.get_question_handle(user_handle) , "0")
  end


end
