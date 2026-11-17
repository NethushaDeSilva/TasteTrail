import 'package:firebase_database/firebase_database.dart';

import '../models/restaurant.dart';
import '../models/review.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseReference _restaurantsRef = FirebaseDatabase.instance
      .ref('restaurants');
  static final DatabaseReference _reviewsRef = FirebaseDatabase.instance.ref(
    'reviews',
  );

  static List<Restaurant> _toRestaurantList(DatabaseEvent event) {
    final Map<dynamic, dynamic>? data =
        event.snapshot.value as Map<dynamic, dynamic>?;
    if (data == null) return [];

    final List<Restaurant> restaurants = data.entries
        .map((entry) => Restaurant.fromMap(entry.key.toString(), entry.value))
        .toList();
    restaurants.sort((a, b) => a.name.compareTo(b.name));
    return restaurants;
  }

  static List<Review> _toReviewList(DatabaseEvent event) {
    final Map<dynamic, dynamic>? data =
        event.snapshot.value as Map<dynamic, dynamic>?;
    if (data == null) return [];

    return data.entries
        .map((entry) => Review.fromMap(entry.key.toString(), entry.value))
        .toList();
  }

  static Stream<List<Restaurant>> restaurantsStream() {
    return _restaurantsRef.onValue.map(_toRestaurantList);
  }

  static Stream<List<Review>> reviewsStream() {
    return _reviewsRef.onValue.map(_toReviewList);
  }

  static Future<void> addReview(Review review) async {
    await _reviewsRef.push().set(review.toMap());
  }

  static Future<void> updateReview(Review review) async {
    await _reviewsRef.child(review.id).update(review.toMap());
  }

  static Future<void> deleteReview(String reviewId) async {
    await _reviewsRef.child(reviewId).remove();
  }

  static Future<void> addRestaurant(Restaurant restaurant) async {
    await _restaurantsRef.push().set(restaurant.toMap());
  }

  static Future<void> updateRestaurant(Restaurant restaurant) async {
    await _restaurantsRef.child(restaurant.id).update(restaurant.toMap());
  }

  static Future<void> deleteRestaurant(String restaurantId) async {
    await _restaurantsRef.child(restaurantId).remove();
  }
}
