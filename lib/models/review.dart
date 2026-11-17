class Review {
  final String id;
  final String restaurantId;
  final String userId;
  final String authorName;
  final double rating;
  final String comment;

  Review({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.authorName,
    required this.rating,
    required this.comment,
  });

  factory Review.fromMap(String id, Map<dynamic, dynamic> map) {
    return Review(
      id: id,
      restaurantId: map['restaurantId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      authorName: map['authorName']?.toString() ?? 'Unknown',
      rating: double.tryParse(map['rating']?.toString() ?? '') ?? 0,
      comment: map['comment']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'userId': userId,
      'authorName': authorName,
      'rating': rating,
      'comment': comment,
    };
  }
}
