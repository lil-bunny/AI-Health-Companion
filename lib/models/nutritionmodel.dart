class NutritionModel {
  final String foodTitle;
  final String totalCalorie;
  final String totalFats;
  final String totalProtein;
  final String totalCarbs;
  final String nutritionalBenefit;
  final String isItSafe;
  final String calorieCheck;

  const NutritionModel({
    required this.foodTitle,
    required this.totalCalorie,
    required this.totalFats,
    required this.totalProtein,
    required this.totalCarbs,
    required this.nutritionalBenefit,
    required this.isItSafe,
    required this.calorieCheck,
  });

  // Factory constructor to create a NutritionModel from a Map
  factory NutritionModel.fromJson(Map<dynamic, dynamic> json) {
    return NutritionModel(
      foodTitle: json['food_title']?.toString() ?? '',
      totalCalorie: json['total_calorie']?.toString() ?? '0',
      totalFats: json['total_fats']?.toString() ?? '0',
      totalProtein: json['total_protien']?.toString() ?? '0', // Note the typo in 'protien'
      totalCarbs: json['total_carbs']?.toString() ?? '0',
      nutritionalBenefit: json['nutritional_benefit']?.toString() ?? '',
      isItSafe: json['is_it_safe']?.toString() ?? '',
      calorieCheck: json['calorie_check']?.toString() ?? '',
    );
  }

  // Method to convert the model back to a Map
  Map<String, dynamic> toJson() {
    return {
      'food_title': foodTitle,
      'total_calorie': totalCalorie,
      'total_fats': totalFats,
      'total_protien': totalProtein, // Maintaining the original key name with typo
      'total_carbs': totalCarbs,
      'nutritional_benefit': nutritionalBenefit,
      'is_it_safe': isItSafe,
      'calorie_check': calorieCheck,
    };
  }

  // Optional: Method to create a copy of the model with ability to override specific fields
  NutritionModel copyWith({
    String? foodTitle,
    String? totalCalorie,
    String? totalFats,
    String? totalProtein,
    String? totalCarbs,
    String? nutritionalBenefit,
    String? isItSafe,
    String? calorieCheck,
  }) {
    return NutritionModel(
      foodTitle: foodTitle ?? this.foodTitle,
      totalCalorie: totalCalorie ?? this.totalCalorie,
      totalFats: totalFats ?? this.totalFats,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      nutritionalBenefit: nutritionalBenefit ?? this.nutritionalBenefit,
      isItSafe: isItSafe ?? this.isItSafe,
      calorieCheck: calorieCheck ?? this.calorieCheck,
    );
  }

  // Optional: Override toString for easy debugging
  @override
  String toString() {
    return 'NutritionModel(foodTitle: $foodTitle, totalCalorie: $totalCalorie, totalFats: $totalFats, totalProtein: $totalProtein, totalCarbs: $totalCarbs)';
  }
}