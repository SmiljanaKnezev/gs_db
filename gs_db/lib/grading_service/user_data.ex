defmodule UserData do

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: User)
  end

  #umesto agenata cemo pozivati bazu

  def add_user(username) do 
     Agent.update(User, fn(state) ->
        Map.put(state, UUID.uuid4(), %{username: username, questions: 0, correct: 0, question_handles: 0}) end)
     Agent.get(User, fn(state) -> List.first(Map.keys(state)) end)
  end

  def add_question_asked(user_handle) do
    update_questions_counter(user_handle)
    add_question_handle(user_handle)
  end

  def update_questions_counter(user_handle) do 
    Agent.update(User, fn(state) ->
      count = get_in(state, [user_handle, :questions])   
      put_in(state, [user_handle, :questions], count + 1) 
    end) 
  end

  def add_question_handle(user_handle) do 
    Agent.update(User, fn(state) ->
     put_in(state,[user_handle, :question_handles], UUID.uuid4())
    end) 
     Agent.get(User, fn(state) -> Map.get(Map.get(state, user_handle), :question_handles) end)
  end

  def check_question_handle?(user_handle, question_handle) do
    Agent.get(User, fn(state) -> String.equivalent?(Map.get(Map.get(state, user_handle), :question_handles), question_handle) end)
  end

  #imam problem prvi put kada  trazi pitanje
  def has_unanswered_question?(user_handle) do
    Agent.get(User, fn(state) -> (Map.get(Map.get(state, user_handle), :question_handles)) != 0 end)
  end

  def add_correct_answer(user_handle) do  
    update_correct_counter(user_handle)
    update_answered_question_handles(user_handle)
  end

  def update_correct_counter(user_handle) do
     Agent.update(User, fn(state) ->
      count = get_in(state, [user_handle, :correct])
      put_in(state, [user_handle, :correct], count + 1) 
    end)
  end

  def update_answered_question_handles(user_handle) do 
     Agent.update(User, fn(state) ->
      put_in(state,[user_handle, :question_handles], 0) 
    end)
  end

  def watch(user_handle) do
    Agent.get(User, fn(state) ->
      Map.get(state, user_handle)
    end)
  end

  def watch_all() do
    Agent.get(User, fn(state) ->
      state
    end)
  end

end
