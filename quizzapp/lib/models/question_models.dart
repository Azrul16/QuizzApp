class Question {
  Question(
      {required this.question,
      required this.category,
      required this.options,
      required this.answer,
      required this.id});

  final String question;
  final int id;
  final String category;
  final List<String> options;
  final int answer;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      id: json['id'] as int,
      category: json['category'] as String,
      options: List<String>.from(json['options'] as List),
      answer: json['answer'] as int,
    );
  }

  // Method to convert a Question object to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'id': id,
      'category': category,
      'options': options,
      'answer': answer,
    };
  }
}
