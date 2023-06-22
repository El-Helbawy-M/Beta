import 'dart:developer';

// ignore: non_constant_identifier_names
void log_check(
    {required String label,
    required dynamic currentValue,
    required dynamic expectedValue}) {
  return log(
      // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
      "Check" +
          "\n" +
          "================================================" +
          "\n" +
          "Test: $label" +
          "\n" +
          "Current Value: $currentValue" +
          "\n" +
          "Expected Value: $expectedValue" +
          "\n" +
          "================================================" +
          "\n" +
          "State: ${expectedValue == currentValue ? "Good" : "Bad"}" +
          "\n" +
          "================================================" +
          "\nEnd" +
          "\n\n");
}

// ignore: non_constant_identifier_names
void log_request(
    {required String request,
    required String requestMethod,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
    Map<String, dynamic> headers = const {}}) {
  return log(
      // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
      "Request" +
          "\n" +
          "================================================" +
          "\n" +
          "Method: $requestMethod" +
          "\n" +
          "The Request $request" +
          "\n" +
          "Headers:$headers" +
          "\n" +
          "Query:$query" +
          "\n" +
          "body:$body" +
          "\n" +
          "================================================" +
          "\nEnd" +
          "\n\n");
}

// ignore: non_constant_identifier_names
void log_error(
    {required String type, required String message, String hint = ""}) {
  return log(
    // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
    "Error" +
        "\n" +
        "================================================" +
        "\n" +
        "Error $type" +
        "\n" +
        "Message: $message" +
        "\n" +
        "Hint: $hint" +
        "\n" +
        "================================================" +
        "\nEnd" +
        "\n\n",
  );
}

// ignore: non_constant_identifier_names
void log_data({required String label, required dynamic message}) {
  return log(
    // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
    "Data" +
        "\n" +
        "================================================" +
        "\n" +
        "Title: $label" +
        "\n" +
        "Content: $message" +
        "\n" +
        "================================================" +
        "\nEnd" +
        "\n\n",
  );
}
