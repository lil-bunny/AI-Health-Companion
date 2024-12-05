import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sahha_flutter_example/Controllers/chatcontroller.dart';
import 'package:sahha_flutter_example/Controllers/usercontroller.dart';
import 'package:sahha_flutter_example/Views/appview/healthmetricschart.dart';
import 'package:sahha_flutter_example/Views/appview/nutritioncard.dart';
import 'package:sahha_flutter_example/models/nutritionmodel.dart';


class ModernChatbotView extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ModernChatbotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
        //   ElevatedButton(onPressed: (){
        //   controller.messages.clear();
        //   controller.finalMessages.clear();
        // }, child: Text('remove')),
        
        
        IconButton(onPressed: (){
print( Get.find<Usercontroller>().finalHealthData[0].toJson());
          showModalBottomSheet(context: context,
          useSafeArea: true,
          isScrollControlled: true,
           builder: (context) => HealthMetricsDashboard(userMetrics: Get.find<Usercontroller>().finalHealthData[0].toJson(),dailyIntakeMetrics:Get.find<ChatController>().todaysdata ,),);
        }, icon: Icon(Icons.dashboard))],
        title: Text(
          'Coolcat AI', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: controller.messages[index],
                );
              },
            )),
          ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.image, color: Colors.black),
              onPressed: controller.pickImage,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return controller.selectedImage.value != null
                        ? Container(
                            height: 80,
                            width: 80,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(controller.selectedImage.value!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }),
                  TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CircularSendButton(onPressed: controller.sendMessage),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  String responseType;

   ChatBubble({Key? key, required this.message,this.responseType=''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(NutritionModel.fromJson(message.nutritionData!));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: 
          message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
               backgroundImage: NetworkImage('https://openseauserdata.com/files/c6883cf63de6ebd7acc59eae8ff676e8.png'),
              backgroundColor: Colors.blue.shade200,
              // child: Icon(
              //   Icons.support_agent,
              //   color: Colors.blue.shade800,
              //   size: 20,
              // ),
            ),
            const SizedBox(width: 8),
          ],
          message.nutritionData!.isNotEmpty?
         
          NutritionCard(title: NutritionModel.fromJson(message.nutritionData!).foodTitle, totalCalorie: NutritionModel.fromJson(message.nutritionData!).totalCalorie, totalFats: NutritionModel.fromJson(message.nutritionData!).totalFats, totalProtein: NutritionModel.fromJson(message.nutritionData!).totalProtein, totalCarbs: NutritionModel.fromJson(message.nutritionData!).totalCarbs, nutritionalBenefit: NutritionModel.fromJson(message.nutritionData!).nutritionalBenefit, isItSafe: NutritionModel.fromJson(message.nutritionData!).isItSafe, calorieCheck:NutritionModel.fromJson(message.nutritionData!).calorieCheck):
          Column(
            crossAxisAlignment: message.isUser 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.start,
            children: [
              if (message.image != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(message.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isUser 
                    ? Colors.blue.shade100 
                    : Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: message.isUser 
                      ? const Radius.circular(15) 
                      : Radius.zero,
                    bottomRight: message.isUser 
                      ? Radius.zero 
                      : const Radius.circular(15),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.isUser ? Colors.blue.shade900 : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircularSendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CircularSendButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 39, 66, 89), Colors.black.withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.send, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}