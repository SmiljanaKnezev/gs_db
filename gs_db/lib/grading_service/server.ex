defmodule GradingService.Server do

  def check_answer(question, answer) do
    generate_questions_map()
    |> Enum.find(fn {_key, val} -> String.equivalent?(List.first(Map.keys(val)), question) end)
    |> Tuple.to_list()
    |> List.last()
    |> Map.values()
    |> Enum.member?(answer)
  end

  def generate_questions_map() do
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

  def generate_question() do
    Map.get(generate_questions_map(), Enum.random(1..11))
  end

  def register(username) do
     UserData.add_user(username)
  end

  # def ask_for_question(user_handle) do
  #   if (cant_get_question?(user_handle)) do
  #     "You have unanswered question, please answer it to get another one"
  #   else
  #   q_handle = UserData.add_question_asked(user_handle) 
  #   #ako imam question handle nije vezan za pitanje, ako ppoturim bilo koje drugo moze da prodje kao tacno
  #   #da napravim jos jednog agenta?
  #   {{:question, List.first(Map.keys(generate_question()))}, {:question_handle, q_handle}} 
  #   end
  # end

  def cant_get_question?(user_handle) do
    UserData.has_unanswered_question?(user_handle)
  end

  def get_question(user_handle) do
     q_handle = UserData.add_question_asked(user_handle) 
    {{:question, List.first(Map.keys(generate_question()))}, {:question_handle, q_handle}} 
  end

  def answer_question(user_handle, question_handle, question, answer) do 
    if(UserData.check_question_handle?(user_handle, question_handle)) do 
      if check_answer(question, answer) do
       UserData.add_correct_answer(user_handle) 
        "The answer is correct"
      else
        "Sorry, wrong answer" 
      end
   end
  end

  def get_statistics(user_handle) do
    data = UserData.watch(user_handle)
    #da ovde ubacim jos username
    "questions: " <> Integer.to_string(Map.get(data, :questions)) <> " correct: " <> Integer.to_string(Map.get(data, :correct))
  end

end
