/// ======================================================
/// ANSWER MODEL
/// ======================================================
class FeedbackAnswerModel {
  final String questionText;
  final String questionType;
  final dynamic answer;
  final dynamic selectedRatingId;
  final dynamic selectedRatingValue;
  final String questionID;

  FeedbackAnswerModel({
    required this.questionText,
    required this.questionType,
    required this.answer,
    this.selectedRatingId,
    this.selectedRatingValue,
    required this.questionID,
  });

  Map<String, dynamic> toJson() {
    return {
      'QuestionText': questionText,
      'QuestionType': questionType,
      'Answer': answer,
      'SelectedRatingId': selectedRatingId,
      'SelectedRatingValue': selectedRatingValue,
      'QuestionID':questionID
    };
  }

  /// Converts this object to one or more formatted strings.
  ///
  /// If selectedRatingId, selectedRatingValue, and answer are Lists,
  /// each index is converted into a separate record.
  ///
  /// Example:
  /// questionID = "Q1"
  /// selectedRatingId = [101, 102]
  /// selectedRatingValue = ["Yes", "No"]
  /// answer = ["Good", "Bad"]
  ///
  /// Output:
  /// Q1~101~Yes~Good-Q1~102~No~Bad
  ///
  static String formatList(List<FeedbackAnswerModel> answers) {
    if (answers.isEmpty) return '';

    final List<String> formattedItems = [];

    for (final item in answers) {
      // Convert all fields to lists for uniform processing
      final List<dynamic> ratingIds = item.selectedRatingId is List
          ? item.selectedRatingId
          : [item.selectedRatingId];

      final List<dynamic> ratingValues = item.selectedRatingValue is List
          ? item.selectedRatingValue
          : [item.selectedRatingValue];

      final List<dynamic> answerValues = item.answer is List
          ? item.answer
          : [item.answer];

      // Determine the maximum number of entries
      final int maxLength = [
        ratingIds.length,
        ratingValues.length,
        answerValues.length,
      ].reduce((a, b) => a > b ? a : b);

      // Create one formatted string for each selected index
      for (int i = 0; i < maxLength; i++) {
        formattedItems.add([
          item.questionID,
          i < ratingIds.length ? (ratingIds[i] ?? '').toString() : '',
          i < ratingValues.length ? (ratingValues[i] ?? '').toString() : '',
          i < answerValues.length ? (answerValues[i] ?? '').toString() : '',
        ].join('~'));
      }
    }

    final result = formattedItems.join('-');
    // print(result);
    return result;
  }



}
