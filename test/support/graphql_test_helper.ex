defmodule Melange.GraphqlTestHelper do
  def graphql_payload(query, query_name \\ nil) do
    %{
      "operationName" => query_name,
      "query" => query,
      "variables" => "{}"
    }
  end

  def graphql_data(decoded_response) do
    decoded_response["data"]
  end

  def graphql_error(decoded_response) do
    if (Map.has_key?(decoded_response, "errors")) do
      hd(decoded_response["errors"])["error"] || decoded_response["errors"]
    else
      :noError
    end
  end

  def graphql_error_message(decoded_response) do
    if (Map.has_key?(decoded_response, "errors")) do
      hd(decoded_response["errors"])["message"]
    else
      ""
    end
  end

  defmacro gql_data(conn, query) do
    quote do
      result = post(unquote(conn), "/api", graphql_payload(unquote(query)))
      decoded_response = json_response(result, 200)
      graphql_data(decoded_response)
    end
  end

  defmacro assert_gql_data(conn, query, data) do
    quote do
      result = post(unquote(conn), "/api", graphql_payload(unquote(query)))
      decoded_response = json_response(result, 200)
      assert decoded_response
      error_message = graphql_error(decoded_response)
      assert(
        error_message == :noError,
        "Unexpected error: '#{error_message}'"
      )
      assert graphql_data(decoded_response) == unquote(data)
    end
  end

  defmacro assert_gql_error_data(conn, query, map, status \\ 200) do
    quote do
      response = post(unquote(conn), "/api", graphql_payload(unquote(query)))
      decoded_response = json_response(response, unquote(status))
      assert decoded_response
      error_message = graphql_error(decoded_response)
      assert(
        :noError != error_message,
        "Expected an error, but there is no error message"
      )
      assert(unquote(map) == error_message)
    end
  end

  defmacro assert_gql_not_authenticated_error(conn, query, status \\ 200) do
    quote do
      response = post(unquote(conn), "/api", graphql_payload(unquote(query)))
      decoded_response = json_response(response, unquote(status))
      assert decoded_response
      error_message = graphql_error_message(decoded_response)
      assert(
        error_message =~ ~r/User is not authenticated/,
        "Message not matching, this is the message: #{error_message}"
      )
    end
  end

  defmacro assert_gql_not_authorized_error(conn, query, status \\ 200) do
    quote do
      response = post(unquote(conn), "/api", graphql_payload(unquote(query)))
      decoded_response = json_response(response, unquote(status))
      assert decoded_response
      error_message = graphql_error_message(decoded_response)
      assert(
        error_message =~ ~r/User is not authorized/,
        "Message not matching, this is the message: #{error_message}"
      )
    end
  end
end
