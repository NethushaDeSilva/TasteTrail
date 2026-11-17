import '../models/review.dart';

/// Average rating and review count for one restaurant.
class RestaurantRating {
  final double average;
  final int count;

  RestaurantRating({required this.average, required this.count});
}

Map<String, RestaurantRating> ratingsByRestaurant(List<Review> reviews) {
  final Map<String, List<double>> grouped = {};
  for (final Review review in reviews) {
    grouped.putIfAbsent(review.restaurantId, () => []).add(review.rating);
  }

  final Map<String, RestaurantRating> result = {};
  grouped.forEach((restaurantId, ratings) {
    final double total = ratings.fold<double>(0, (sum, rating) => sum + rating);
    final double rounded = double.parse(
      (total / ratings.length).toStringAsFixed(1),
    );
    result[restaurantId] = RestaurantRating(
      average: rounded,
      count: ratings.length,
    );
  });
  return result;
}
