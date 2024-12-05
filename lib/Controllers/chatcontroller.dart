import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sahha_flutter_example/Controllers/usercontroller.dart';
import 'package:sahha_flutter_example/helper/openaiservice.dart';
import 'package:sahha_flutter_example/models/userdatamodel.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final File? image;
  Map<dynamic,dynamic>? nutritionData;
  String responseType='';


  ChatMessage({
    required this.text, 
    required this.isUser, 
    this.image,
    this.nutritionData=const{},
    this.responseType='',
  });
}

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  var currentUri='';
  var finalMessages=[].obs;
   var todaysdata={
    "todayprotienintake":0,
    "todaycarbintake":0,
    "todayfatintake":0,
    "todaytotalcalorie":0,
   };
   
  void addUserMessageImage(imgurl,usertext){
      finalMessages.add( {
      "role": "user",
      "parts": [
        {
          "fileData": {
            "fileUri": imgurl,
            "mimeType": "image/webp"
          }
        },
        {
          "text": usertext
        }
      ]
    },);
  }

  void addUserMessageNormal(usertext){
      finalMessages.add( {
      "role": "user",
      "parts": [
       
        {
          "text": usertext
        }
      ]
    },);
  }

   void addBotMessageNormal(bottext){
      finalMessages.add( {
      "role": "model",
      "parts": [
       
        {
          "text": bottext
        }
      ]
    },);
  }
  final TextEditingController messageController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
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
  getFoodAnalysisPrompt(){
    var userData=Get.find<Usercontroller>();
    UserModel finalHealthData=userData.finalHealthData[0];
  
    var todayCalorieIntake=finalHealthData.dailyCalorieIntake;
    return """MY HEALTH DATA:${finalHealthData.toJson()}
    My daily calorie intakelimit=${todayCalorieIntake}.\n Extract the total calorie,total protien,total carbs.total fats,from the food image,nutrtional benefit(if any).Give response like you are telling me,mention me as 'You', in Json format only:{
    food_title:"title of the food"
    total_calorie:"total calorie of this food in image in INT",total_fats:(in gm,in INT),"total_protien":"in gm,in INT","total_carbs":"in gmin INT","nutritional_benefit":"","is_it_safe":"explain based on <MY HEALTH DATA>  ","calorie_check":"give comments based on today calorie intake shall the user eat this,and if they eat what to keep in mind based on everydayalorielimit=${todayCalorieIntake}? give  in number.The user has eaten 0 calorie till now"}""";
  }
  void sendMessage()async { 
    if (messageController.text.isEmpty && selectedImage.value == null) return;
if(selectedImage.value!=null){
  messages.add(ChatMessage(
      text:'Can i eat it ?',
      isUser: true,
      image: selectedImage.value
    ));

     

    var resp=await GeminiApiService('AIzaSyBYtsz7DH8IiPvWpvfwFK6KVTDxZlvYFyE').analyzeNutrition(imageFile: selectedImage.value!, prompt: getFoodAnalysisPrompt());
    print("gemini=${resp}");
    addUserMessageImage(currentUri, 'Get calorie details');
    // Clear input after sending
    messageController.clear();
    selectedImage.value = null;

    // // Simulate bot response
    // 
    addBotMessageNormal(jsonEncode(resp.toString().replaceAll('{', "").replaceAll("}","").replaceAll(":", "")));
    simulateBotResponseImage(resp);
 

}else{

   addUserMessageNormal(messageController.text);
    messages.add(ChatMessage(
      text: messageController.text,
      isUser: true,
      image: selectedImage.value
    ));

     
   debugPrint(finalMessages.toString());
    var userData=Get.find<Usercontroller>();
    UserModel finalHealthData=userData.finalHealthData[0];
var resp=await GeminiApiService('AIzaSyBYtsz7DH8IiPvWpvfwFK6KVTDxZlvYFyE').askBot(prompt:"user-question:"+ messageController.text+'\n ');
print("whole resp=${resp}");

simulateBotResponse(resp.toString());
 messageController.clear();
    selectedImage.value = null;


}
  
  }
 void simulateBotResponseImage(Map data) {
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(ChatMessage(
        text: '',
        nutritionData: data,
        isUser: false,
      ));
    });
  }
  void simulateBotResponse(text) {
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(ChatMessage(
        text: text,
        isUser: false,
      ));
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  void onInit(){
    super.onInit();
     messages.add(ChatMessage(
        text: 'Hey am Coolcat AI,i will help you to achieve your fitness 🏋 & nutrition 🍏 goals tailored for your health data .If you have any questions or need any suggestions i am always there to help. ',
        
        isUser: false,
      ));
  }
}