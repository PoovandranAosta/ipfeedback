// class QuestionModel {
//   final String questionText;
//   final String questionType; // Rating | YesNo | Text
//   final List<String> options;
//   final List<int> ratingValues;
//   final List<int> ratingIds;
//
//   QuestionModel({
//     required this.questionText,
//     required this.questionType,
//     required this.options,
//     required this.ratingValues,
//     required this.ratingIds,
//   });
//
//   factory QuestionModel.fromJson(Map<String, dynamic> json) {
//     List<String> parseStringList(String? value) {
//       if (value == null || value.trim().isEmpty) return [];
//       return value
//           .split(',')
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();
//     }
//
//     List<int> parseIntList(String? value) {
//       if (value == null || value.trim().isEmpty) return [];
//       return value
//           .split(',')
//           .map((e) => int.tryParse(e.trim()))
//           .whereType<int>()
//           .toList();
//     }
//
//     final questionType = (json['QuestionType'] ?? '').toString().trim();
//     final options = parseStringList(
//       (json['RatingText'] ?? json['Options'] ?? '').toString(),
//     );
//
//     final normalizedOptions =
//     questionType.toLowerCase() == 'yesno' && options.isEmpty
//         ? ['Yes', 'No']
//         : options;
//
//     return QuestionModel(
//       questionText: (json['QuestionText'] ?? '').toString(),
//       questionType: questionType,
//       options: normalizedOptions,
//       ratingValues: parseIntList((json['RatingValue'] ?? '').toString()),
//       ratingIds: parseIntList((json['Ratingid'] ?? '').toString()),
//     );
//   }
// }

class QuestionModel {
  final String displayOrder;
  final String questionText;
  final String questionType;
  final List<String> options;
  final List<int> ratingValues;
  final List<int> ratingIds;
  final String questionID;


  QuestionModel({
    required this.displayOrder,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.ratingValues,
    required this.ratingIds,
    required this.questionID,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(String? value) {
      if (value == null || value.trim().isEmpty) return [];
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    List<int> parseIntList(String? value) {
      if (value == null || value.trim().isEmpty) return [];
      return value
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .toList();
    }

    final questionType = (json['QuestionType'] ?? '').toString().trim();
    final options = parseStringList(
      (json['RatingText'] ?? json['Options'] ?? '').toString(),
    );

    final normalizedOptions =
    (questionType.toLowerCase() == 'yesno' ||
        questionType.toLowerCase() == 'crating') &&
        options.isEmpty
        ? ['Yes', 'No']
        : options;

    return QuestionModel(
      displayOrder: (json['DisplayOrder'] ?? '').toString(),
      questionText: (json['QuestionText'] ?? '').toString(),
      questionType: questionType,
      options: normalizedOptions,
      ratingValues: parseIntList((json['RatingValue'] ?? '').toString()),
      ratingIds: parseIntList((json['Ratingid'] ?? '').toString()),
      questionID: (json['QuestionID'] ?? '').toString(),
    );
  }
}
