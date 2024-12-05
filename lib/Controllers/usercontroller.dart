import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sahha_flutter_example/helper/openaiservice.dart';
import 'package:sahha_flutter_example/models/userdatamodel.dart';




class Usercontroller extends GetxController{

 
var userdata={
  "question":"user",
  "user_answer":"userans"
};
var onboardingMessagelist=<Map<String,String>>[].obs;
var onboardingLoading=false.obs;
var userHealthData={}.obs;
var finalHealthData=<UserModel>[].obs;
var analyzingdata=false.obs;
var initialMessage=[{
  "role":"user",
  "content":"Act as an health assistant and nutrition assistant named Coolcat and ask me questions like my name is gender height and what type of food I eat like veg non veg or other and also ask me like how much time I workout in a week and also ask me , and also ask me do I have any disease like diabetes for example diabetes and other example etc and also ask me about my goal so do I want to weight loss or what,ask current height.ask current weight,then target weight,then current age.Dont put number in question and be professional and casual both.\n\nAsk this one after another like first ask one question and after I finish then go to next.\nstay focused on question and dont entertain unnecessaary question and restrict to the question end question should be question related to goal. and after that question say \"COMPLETED\"only\n"
}];


Map<dynamic, dynamic> parseUserHealthData(String healthDataString) {
  // Remove the Flutter log prefix and trim whitespace
  String cleanedData = healthDataString.replaceFirst(RegExp(r'I/flutter \(\d+\):\s*'), '');
  
  // Remove curly braces and split into key-value pairs
  List<String> pairs = cleanedData
      .replaceAll('{', '')
      .replaceAll('}', '')
      .split(',')
      .map((pair) => pair.trim())
      .toList();
  
  // Create the map
  Map<String, dynamic> healthData = {};
  
  for (String pair in pairs) {
    // Split each pair into key and value
    List<String> keyValue = pair.split(':');
    
    if (keyValue.length == 2) {
      String key = keyValue[0].trim().replaceAll('"', '');
      String value = keyValue[1].trim().replaceAll('"', '');
      
      // Try to convert to appropriate type
      dynamic parsedValue;
      if (int.tryParse(value) != null) {
        parsedValue = int.parse(value);
      } else {
        parsedValue = value;
      }
      
      healthData[key] = parsedValue;
    }
  }
  
  return healthData;
}
 analyzeUserData(VoidCallback nextPage)async{
    var prompt="""
${onboardingMessagelist.value.toString()}
\nBased on this above conversation of user with health assistant bot
extract the follwing data in below JSON format only:
age:age of user
name:name of user
diseases:csv string of disease of user if any
goalofuser:Either Weight loss or Weight gain or Maintain Weight
currentweightofuser:currentweight in kg
targetweightofuser:target weight in kg
weightmeasurement:kg
heightofuser:height of user
noofworkoutinaweek:number of workout user does in a week
genderofuser:gender of the user
foodpreferenceofuser:csv format of food preference of user""";
   var response=await GroqAIService().analyzeOnboardingData(messages:[{"role":"user","content":prompt}] );
print(response['choices'][0]['message']['content']);
userHealthData.value= parseUserHealthData(response['choices'][0]['message']['content'].toString());
print("done bencho");
var response2=await GroqAIService().calculateUserMetrics(userHealthData.value);
userHealthData.value.addAll(parseUserHealthData(response2.toString()));
debugPrint("final healthdata===${userHealthData.value}"  );
finalHealthData.value=[UserModel.fromJson(userHealthData)];
print(finalHealthData);
nextPage();

}
Future<void> sendOnboardingMessage({userText=''})async{
  if(userText!='')
  {onboardingMessagelist.value.add({"role":"user","content":userText});}
  onboardingLoading.value=true;
  var reply=await GroqAIService().callGroqAPI(messages:
  onboardingMessagelist.value.length==0?initialMessage:
   onboardingMessagelist.value);
     onboardingLoading.value=false;
  if(userText==''){
    onboardingMessagelist.add(initialMessage[0]);
    
  }
  onboardingMessagelist.add({"role":"assistant","content":reply
  });
  onboardingMessagelist.refresh();
  


}

  @override 
  void onInit(){
    super.onInit();
    sendOnboardingMessage();
    
    
  }
}