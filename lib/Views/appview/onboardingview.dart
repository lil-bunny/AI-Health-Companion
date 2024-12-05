import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sahha_flutter_example/Controllers/usercontroller.dart';
import 'package:sahha_flutter_example/Views/appview/mainchatbot.dart';

class Onboardingview extends StatefulWidget {
  const Onboardingview({super.key});

  @override
  State<Onboardingview> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<Onboardingview> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  var controller=Get.put(Usercontroller());

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _textController.clear();

      // Simulated bot response
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(ChatMessage(
            text: "This is a sample bot response",
            isUser: false,
          ));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Coolcat AI',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [

            Expanded(
              child: ListView.builder(
                reverse: false,
                padding: const EdgeInsets.all(16),
                itemCount: controller.onboardingMessagelist.value.length,
                itemBuilder: (context, index) {
                  return controller.onboardingMessagelist.value.length>1 && index==0?
                    Container():

                
                  
                   ChatBubble(
                    text: controller.onboardingMessagelist[index]['content'].toString(),
                    isUser: controller.onboardingMessagelist[index]['role']=='user',
                  );
                },
              ),
            ),
          _buildMessageInputArea()  
          ],
        ),
        // bottomNavigationBar: _buildMessageInputArea(),
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
      child: 
        controller.analyzingdata.value?Center(child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('AI is analyzing'),
            CircularProgressIndicator(color: Colors.black,)
          ],
        ),):
       controller.onboardingMessagelist.length>1 && controller.onboardingMessagelist[controller.onboardingMessagelist.length-1]['content'].toString().toLowerCase().contains('completed')?
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.black)),
                onPressed: (){
                controller.analyzingdata.value=true;
                controller.analyzeUserData((){
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ModernChatbotView(),));
                   controller.analyzingdata.value=false;
                });
               
               
                }, child: Text('Next',style: TextStyle(color: Colors.white),)),
            ):
      SafeArea(
        child:
        
         Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
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
                onSubmitted: _handleSubmitted,
              ),
            ),
            const SizedBox(width: 10),
           
            CircularIconButton(
              icon: Icons.send,
              onPressed: () {
                controller.sendOnboardingMessage(userText:  _textController.text);
                _textController.clear();
                }
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: 
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
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
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser 
                ? Colors.blue.shade100 
                : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isUser 
                  ? const Radius.circular(15) 
                  : Radius.zero,
                bottomRight: isUser 
                  ? Radius.zero 
                  : const Radius.circular(15),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.blue.shade900 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}