class Question {
  Question({
    required this.question,
    required this.category,
    required this.options1,
    required this.options2,
    required this.options3,
    required this.options4,
    required this.answer,
    required this.id,
  });

  final String question;
  final String id;
  final String category;
  final String options1;
  final String options2;
  final String options3;
  final String options4;
  final String answer;

  factory Question.fromJson(Map<String, dynamic> json, String docID) {
    return Question(
      question: json['question'] as String,
      id: docID,
      category: json['category'] as String,
      options1: json['options1'] as String,
      options2: json['options2'] as String,
      options3: json['options3'] as String,
      options4: json['options4'] as String,
      answer: json['answer'] as String,
    );
  }

  // Method to convert a Question object to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'category': category,
      'options1': options1,
      'options2': options2,
      'options3': options3,
      'options4': options4,
      'answer': answer,
    };
  }
}
