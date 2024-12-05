import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sahha_flutter_example/Controllers/chatcontroller.dart';
import 'package:sahha_flutter_example/Controllers/usercontroller.dart';

class NutritionCard extends StatelessWidget {
  final String title;
  final String totalCalorie;
  final String totalFats;
  final String totalProtein;
  final String totalCarbs;
  final String nutritionalBenefit;
  final String isItSafe;
  final String calorieCheck;

  const NutritionCard({
    Key? key,
    required this.title,
    required this.totalCalorie,
    required this.totalFats,
    required this.totalProtein,
    required this.totalCarbs,
    required this.nutritionalBenefit,
    required this.isItSafe,
    required this.calorieCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.75,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
      
              // Nutritional Information
              _buildNutritionalRow('Total Calories', '$totalCalorie kcal'),
              _buildNutritionalRow('Total Fats', '$totalFats g'),
              _buildNutritionalRow('Total Protein', '$totalProtein g'),
              _buildNutritionalRow('Total Carbs', '$totalCarbs g'),
      
              const SizedBox(height: 16),
      
              // Nutritional Benefit
              _buildSectionTitle('Nutritional Benefit'),
              Text(
                nutritionalBenefit,
                style: const TextStyle(color: Colors.black54),
              ),
      
              const SizedBox(height: 16),
      
              // Safety Warning
              _buildWarningSection('Health Advisory', isItSafe),
      
              const SizedBox(height: 16),
      
              // Calorie Check
              _buildWarningSection('Calorie Check', calorieCheck),
              Center(
                child: ElevatedButton(onPressed: (){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added the meal')));
                  var controller=Get.find<ChatController>();
              
                  controller.todaysdata={
                   "todayprotienintake": controller.todaysdata[ "todayprotienintake"]!+int.parse(this.totalProtein),
    "todaycarbintake": controller.todaysdata!["todaycarbintake"]!+int.parse(this.totalCarbs),
    "todayfatintake": controller.todaysdata["todayfatintake"]!+int.parse(this.totalFats),
    "todaytotalcalorie": controller.todaysdata![ "todaytotalcalorie"]!+int.parse(this.totalCalorie),
                  };
                  print(controller.todaysdata);
                }, child: Text('Eat it 😋')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildWarningSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade300),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.red.shade800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}