defmodule GradingServiceTest do
  use ExUnit.Case
  doctest GradingService

  test "greets the world" do
    assert GradingService.hello() == :world
  end
end
