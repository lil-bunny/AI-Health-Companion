import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sahha_flutter_example/Controllers/usercontroller.dart';
import 'package:sahha_flutter_example/Views/HomeView.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HealthMetricsDashboard extends StatelessWidget {
  final Map<String, dynamic> userMetrics;
  final Map<String, dynamic> dailyIntakeMetrics;

  const HealthMetricsDashboard({
    Key? key, 
    required this.userMetrics, 
    required this.dailyIntakeMetrics
  }) : super(key: key);
 int _calculateHealthPoints() {
    // Calculate health points based on available metrics
    int points = 0;

    // Weight progress points
    double weightProgress = double.parse(userMetrics['currentweightofuser']) / 
                            double.parse(userMetrics['targetweightofuser']);
    points += _calculateSubPoints(weightProgress, 20);

    // Workout points
    int workoutsPerWeek = int.parse(userMetrics['noofworkoutinaweek'].toString());
    points += workoutsPerWeek * 10;

    // Calorie intake points
    int dailyIntake = int.parse(dailyIntakeMetrics['todaytotalcalorie'].toString());
    int maintenanceCalorie = int.parse(userMetrics['maintencecalorie'].toString());
    double calorieRatio = dailyIntake / maintenanceCalorie;
    points += _calculateSubPoints(calorieRatio, 30);

    // Nutrition balance points
    int dailyProtein = int.parse(userMetrics['dailyprotienrequirement'].toString());
    int dailyCarbs = int.parse(userMetrics['dailycarbsrequirement'].toString());
    int dailyFats = int.parse(userMetrics['dailyfatsrequirement'].toString());

    int todayProtein = int.parse(dailyIntakeMetrics['todayprotienintake'].toString());
    int todayCarbs = int.parse(dailyIntakeMetrics['todaycarbintake'].toString());
    int todayFats = int.parse(dailyIntakeMetrics['todayfatintake'].toString());

    double proteinRatio = todayProtein / dailyProtein;
    double carbRatio = todayCarbs / dailyCarbs;
    double fatRatio = todayFats / dailyFats;

    points += _calculateSubPoints(proteinRatio, 10);
    points += _calculateSubPoints(carbRatio, 10);
    points += _calculateSubPoints(fatRatio, 10);

    // Ensure points are within a reasonable range
    return points.clamp(0, 100);
  }

  int _calculateSubPoints(double ratio, int maxPoints) {
    if (ratio <= 0.5) return 0;
    if (ratio <= 0.8) return (maxPoints * 0.5).round();
    if (ratio <= 1.2) return maxPoints;
    return maxPoints;
  }

  Widget _buildHealthPointsSection() {
    int healthPoints = _calculateHealthPoints();
    String pointsEmoji = _getHealthPointsEmoji(healthPoints);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade200, 
            Colors.deepPurple.shade100
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Points 🏆',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$healthPoints/100',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepPurple.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _getHealthPointsDescription(healthPoints),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Text(
              pointsEmoji,
              style: TextStyle(fontSize: 40),
            ),
          ),
        ],
      ),
    );
  }

  String _getHealthPointsEmoji(int points) {
    if (points < 30) return '💀';
    if (points < 50) return '😓';
    if (points < 70) return '💪';
    if (points < 90) return '🔥';
    return '🏆';
  }

  String _getHealthPointsDescription(int points) {
    if (points < 30) return 'Needs Major Improvement';
    if (points < 50) return 'On the Right Track';
    if (points < 70) return 'Getting Stronger!';
    if (points < 90) return 'Fitness Champion!';
    return 'Ultimate Health Legend! 🌟';
  }

  @override
  Widget build(BuildContext context) {
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              _buildPersonalInfoCard(),
             _buildHealthPointsSection(), // New health points section

              _buildMetricsGrid(),
              _buildCalorieTrackerSection(),
              _buildNutritionBreakdownSection(),(
              ElevatedButton(onPressed: ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeView(),));
              }, child:Text('Connect to Sahha AI')))
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${userMetrics['name']}, ${userMetrics['age']} years',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade800,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip('Gender', userMetrics['genderofuser']),
              _buildInfoChip('Goal', userMetrics['goalofuser']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      padding: EdgeInsets.all(16),
      children: [
        _buildMetricCard('Current Weight', '${userMetrics['currentweightofuser']} ${userMetrics['weightmeasurement']}', Icons.monitor_weight),
        _buildMetricCard('Target Weight', '${userMetrics['targetweightofuser']} ${userMetrics['weightmeasurement']}', Icons.trending_down),
        _buildMetricCard('BMI', userMetrics['bmi'].toString(), Icons.calculate),
        _buildMetricCard('Workouts/Week', userMetrics['noofworkoutinaweek'].toString(), Icons.fitness_center),
      ],
    );
  }

  Widget _buildCalorieTrackerSection() {
    int maintenanceCalorie = int.parse(userMetrics['maintencecalorie'].toString());
    int dailyIntake = int.parse(dailyIntakeMetrics['todaytotalcalorie'].toString());
    int remainingCalories = int.parse(Get.find<Usercontroller>().userHealthData['dailycalorieintake'].toString()) - dailyIntake;

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade100, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calorie Tracker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCalorieCard('Calorie Budget', int.parse(Get.find<Usercontroller>().userHealthData['dailycalorieintake'].toString()), Icons.local_fire_department),
              _buildCalorieCard('Consumed', dailyIntake, Icons.food_bank),
              _buildCalorieCard('Remaining', remainingCalories, Icons.timelapse),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard(String title, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 30),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade800,
          ),
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionBreakdownSection() {
    // Convert string values to int
    int dailyProtein = int.parse(userMetrics['dailyprotienrequirement'].toString());
    int dailyCarbs = int.parse(userMetrics['dailycarbsrequirement'].toString());
    int dailyFats = int.parse(userMetrics['dailyfatsrequirement'].toString());

    int todayProtein = int.parse(dailyIntakeMetrics['todayprotienintake'].toString());
    int todayCarbs = int.parse(dailyIntakeMetrics['todaycarbintake'].toString());
    int todayFats = int.parse(dailyIntakeMetrics['todayfatintake'].toString());

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Breakdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 10),
          _buildNutritionProgressRow('Protein', todayProtein, dailyProtein),
          _buildNutritionProgressRow('Carbs', todayCarbs, dailyCarbs),
          _buildNutritionProgressRow('Fats', todayFats, dailyFats),
        ],
      ),
    );
  }

  Widget _buildNutritionProgressRow(String nutrient, int consumed, int daily) {
    double progress = consumed / daily;
    Color progressColor = _getProgressColor(progress);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nutrient,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              Text(
                '$consumed/$daily g',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.5) return Colors.red.shade400;
    if (progress < 0.8) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.deepPurple, size: 40),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.deepPurple.shade700,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.white.withOpacity(0.7),
    );
  }
}
