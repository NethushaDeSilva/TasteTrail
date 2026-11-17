import 'dart:async';

import '../models/restaurant.dart';
import '../models/review.dart';

/// In-memory, non-persisted replacement for the old Firebase Realtime
/// Database-backed DatabaseService. No real backend: data only lives for the
/// current app session and resets on restart.
class DatabaseService {
  DatabaseService._();

  static final List<Restaurant> _restaurants = <Restaurant>[];
  static final List<Review> _reviews = <Review>[];

  static final StreamController<List<Restaurant>> _restaurantsController =
      StreamController<List<Restaurant>>.broadcast();
  static final StreamController<List<Review>> _reviewsController =
      StreamController<List<Review>>.broadcast();

  static int _nextRestaurantId = 1;
  static int _nextReviewId = 1;

  static List<Restaurant> _sortedRestaurants() {
    final List<Restaurant> copy = List<Restaurant>.from(_restaurants);
    copy.sort((a, b) => a.name.compareTo(b.name));
    return copy;
  }

  static void _emitRestaurants() {
    _restaurantsController.add(_sortedRestaurants());
  }

  static void _emitReviews() {
    _reviewsController.add(List<Review>.from(_reviews));
  }

  static Stream<List<Restaurant>> restaurantsStream() async* {
    yield _sortedRestaurants();
    yield* _restaurantsController.stream;
  }

  static Stream<List<Review>> reviewsStream() async* {
    yield List<Review>.from(_reviews);
    yield* _reviewsController.stream;
  }

  static Future<void> addReview(Review review) async {
    final Review stored = Review(
      id: 'local-review-${_nextReviewId++}',
      restaurantId: review.restaurantId,
      userId: review.userId,
      authorName: review.authorName,
      rating: review.rating,
      comment: review.comment,
      visitType: review.visitType,
      visitDate: review.visitDate,
    );
    _reviews.add(stored);
    _emitReviews();
  }

  static Future<void> updateReview(Review review) async {
    final int index = _reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      _reviews[index] = review;
      _emitReviews();
    }
  }

  static Future<void> deleteReview(String reviewId) async {
    _reviews.removeWhere((r) => r.id == reviewId);
    _emitReviews();
  }

  static Future<void> addRestaurant(Restaurant restaurant) async {
    final Restaurant stored = Restaurant(
      id: 'local-restaurant-${_nextRestaurantId++}',
      ownerId: restaurant.ownerId,
      name: restaurant.name,
      cuisine: restaurant.cuisine,
      area: restaurant.area,
      rating: restaurant.rating,
      priceRange: restaurant.priceRange,
      imageUrl: restaurant.imageUrl,
      description: restaurant.description,
      popularDishes: restaurant.popularDishes,
      latitude: restaurant.latitude,
      longitude: restaurant.longitude,
    );
    _restaurants.add(stored);
    _emitRestaurants();
  }

  static Future<void> updateRestaurant(Restaurant restaurant) async {
    final int index = _restaurants.indexWhere((r) => r.id == restaurant.id);
    if (index != -1) {
      _restaurants[index] = restaurant;
      _emitRestaurants();
    }
  }

  static Future<void> deleteRestaurant(String restaurantId) async {
    _restaurants.removeWhere((r) => r.id == restaurantId);
    _emitRestaurants();
  }
}
