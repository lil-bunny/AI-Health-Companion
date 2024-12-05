class UserModel {
  final String age;
  final String name;
  final String diseases;
  final String goalOfUser;
  final String currentWeightOfUser;
  final String targetWeightOfUser;
  final String heightOfUser;
  final String noOfWorkoutInAWeek;
  final String genderOfUser;
  final String foodPreferenceOfUser;
  final String maintenanceCalorie;
  final String dailyProteinRequirement;
  final String dailyCarbsRequirement;
  final String dailyFatsRequirement;
  final String deficitCalories;
  // final String maxCalories;
  final String bmi;
  final String dailyCalorieIntake;

  UserModel({
    required this.age,
    required this.name,
    required this.dailyCalorieIntake,
    required this.diseases,
    required this.goalOfUser,
    required this.currentWeightOfUser,
    required this.targetWeightOfUser,
    required this.heightOfUser,
    required this.noOfWorkoutInAWeek,
    required this.genderOfUser,
    required this.foodPreferenceOfUser,
    required this.maintenanceCalorie,
    required this.dailyProteinRequirement,
    required this.dailyCarbsRequirement,
    required this.dailyFatsRequirement,
    required this.deficitCalories,
    // required this.maxCalories,
    required this.bmi,
  });

  // Factory constructor for creating a UserModel from a JSON map
  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      age: (json['age'] ?? 0).toString(),
      name: json['name'] ?? '',
      diseases: json['diseases'] ?? '',
      goalOfUser: json['goalofuser'] ?? '',
      currentWeightOfUser: (json['currentweightofuser'] ?? 0).toString(),
      targetWeightOfUser: (json['targetweightofuser'] ?? 0).toString(),
      heightOfUser: json['heightofuser'] ?? '',
      noOfWorkoutInAWeek: (json['noofworkoutinaweek'] ?? 0).toString(),
      genderOfUser: json['genderofuser'] ?? '',
      foodPreferenceOfUser: json['foodpreferenceofuser'] ?? '',
      maintenanceCalorie: (json['maintencecalorie'] ?? 0).toString(),
      dailyProteinRequirement: (json['dailyprotienrequirement'] ?? 0).toString(),
      dailyCalorieIntake: (json['dailycalorieintake'] ?? 0).toString(),
      dailyCarbsRequirement: (json['dailycarbsrequirement'] ?? 0).toString(),
      dailyFatsRequirement: (json['dailyfatsrequirement'] ?? 0).toString(),
      deficitCalories: (json['deficitcalories'] ?? 0).toString(),
      // maxCalories: (json['maxcalories'] ?? 0).toString(),
      bmi: (json['bmi'] ?? 0).toString(),
    );
  }

  // Method to convert UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'name': name,
      'diseases': diseases,
      'goalofuser': goalOfUser,
      'currentweightofuser': currentWeightOfUser,
      'targetweightofuser': targetWeightOfUser,
      'heightofuser': heightOfUser,
      'noofworkoutinaweek': noOfWorkoutInAWeek,
      'genderofuser': genderOfUser,
      'foodpreferenceofuser': foodPreferenceOfUser,
      'maintencecalorie': maintenanceCalorie,
      'dailyprotienrequirement': dailyProteinRequirement,
      'dailycarbsrequirement': dailyCarbsRequirement,
      'dailyfatsrequirement': dailyFatsRequirement,
      'deficitcalories': deficitCalories,
      // 'maxcalories': maxCalories,
      'bmi': bmi,
    };
  }

  // Utility method to convert string to int if needed
  int? toInt(String value) {
    return int.tryParse(value);
  }

  // Utility method to convert string to double if needed
  double? toDouble(String value) {
    return double.tryParse(value);
  }
}