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
      hd(decoded_response["errors"])["message"]
    else
      ""
    end
  end

  defmacro assert_gql_data(conn, query, data) do
    quote do
      result = post(unquote(conn), "/api", graphql_payload(unquote(query)))
      decoded_response = json_response(result, 200)
      assert decoded_response
      error_message = graphql_error(decoded_response)
      assert(
        error_message == "",
        "Error message is not empty: '#{error_message}'"
      )
      assert graphql_data(decoded_response) == unquote(data)
    end
  end

  defmacro assert_gql_error(conn, query, message, status \\ 200) do
    quote do
      response = post(unquote(conn), "/api", graphql_payload(unquote(query)))
      decoded_response = json_response(response, unquote(status))
      assert decoded_response
      error_message = graphql_error(decoded_response)
      assert(
        Regex.match?(
          unquote(message),
          error_message
        ),
        "Error message does not match, message: '#{error_message}'"
      )
    end
  end
end
