defmodule GradingService.Router do

  require Logger
  use Plug.Router

  plug Plug.Logger
#   plug Plug.Parsers, parsers: [:urlencoded, :json],
#                      pass:  ["*/*"],
#                      json_decoder: Poison

plug Plug.Parsers, parsers: [:json],
                    pass:  ["application/json"],
                    json_decoder: Poison
                  #  json_decoder: Jason #probam sa poison-om


#- Use usvc
#- Use plain JSON
#- Use curl as a client (edited)
# error handling, ako prosledim user_handle koji ne postoji u get question, pukne

  plug :match
  plug :dispatch


  post "/register" do
    {:ok, username} = Map.fetch(conn.body_params, "username")
    user_handle = GradingService.Server.register(username) 
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{user_handle: user_handle}))
  end

  post "/get_question" do
    {:ok, user_handle} = Map.fetch(conn.body_params, "user_handle")
    if GradingService.Server.cant_get_question?(user_handle) do
      unanswered_response(conn)
    else
      question_response(user_handle, conn)
     end
  end

  defp question_response(user_handle, conn) do
        {{:question, question}, {:question_handle, q_handle}} = GradingService.Server.get_question(user_handle)
     conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{question: question, question_handle: q_handle}))

  end

  defp unanswered_response(conn) do
    response = "You have unanswered question, please answer it to get another one"
      conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{response: response}))
  end

  post "/statistics" do
    {:ok, user_handle} = Map.fetch(conn.body_params, "user_handle")
    stat = GradingService.Server.get_statistics(user_handle)
    #send_resp(conn, 200, "Statistics for #{username} : #{inspect stat}")
     conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{statistics: stat}))
  end


   post "/answer" do
    {:ok, user_handle} = Map.fetch(conn.body_params, "user_handle")
    {:ok, question} = Map.fetch(conn.body_params, "question")
    {:ok, question_handle} = Map.fetch(conn.body_params, "question_handle")
    {:ok, answer} = Map.fetch(conn.body_params, "answer")
    response = GradingService.Server.answer_question(user_handle, question_handle, question, answer) 
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{response: response}))
    end

 # post "/answer" do
    # {:ok, username} = Map.fetch(conn.body_params, "username")
    # {:ok, question} = Map.fetch(conn.body_params, "question")
    # {:ok, answer} = Map.fetch(conn.body_params, "answer")
    # answ = GradingService.Server.answer_question(username, question, answer)
    # send_resp(conn, 200, "#{answ}")
  #end

  # post "/hello" do
  #  IO.inspect conn.body_params
  #  send_resp(conn, 200, "Success!")
  # end

  get "/grading-service" do
    send_resp(conn, 200, "Hello micro-service!")
  end

  get "/health_check/ping" do
    send_resp(conn, 200, "pong")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

end
