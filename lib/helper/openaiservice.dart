import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:sahha_flutter_example/Controllers/chatcontroller.dart';
import 'package:sahha_flutter_example/Controllers/usercontroller.dart';


class GroqAIService{
  final Dio _dio=Dio();
var apiKey="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";
Future<dynamic> calculateUserMetrics(Map<dynamic, dynamic> userData) async {
  final dio = Dio();
  
  try {
    final response = await dio.post(
      'https://api.groq.com/openai/v1/chat/completions',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiKey}'
        },
      ),
      data: {
        "messages": [
        
          {
            "role": "user",
            "content": jsonEncode(userData) + 
              "\n\nBased on the the above user data Calculate BMI of the user\n" +
              "and return in below json format only\n" +
              "maintainencecalorie:\n" +
              "dailycalorieintake:\n"+
              "dailyprotienrequirement:\n" +
              "dailycarbsrequirement:\n" +
              "dailyfatsrequirement:\n" +
              "deficitcalories:\n"
              //  +
              // "maxcalories:"
          }
        ],
        "model": "llama-3.1-70b-versatile",
        "temperature": 0,
        "max_tokens": 1024,
        "top_p": 1,
        "stream": false,
        "response_format": {
          "type": "json_object"
        },
        "stop": null
      }
    );
    
    return response.data['choices'][0]['message']['content'];
  } on DioException catch (e) {
    print('Error occurred: \$\{e.response?.data ?? e.message\}');
    rethrow;
  }
}
 
  

Future<dynamic> analyzeOnboardingData({
    required List<Map<String, dynamic>> messages,
    String model = 'llama-3.1-70b-versatile',
    double temperature = 0.0,
    int maxTokens = 1024,
    double topP = 1.0,
    bool stream = false,
  }) async {
    try {
      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'messages': messages,
          'model': model,
          'temperature': temperature,
          'max_tokens': maxTokens,
          'top_p': topP,
          'stream': stream,
          'response_format': {'type': 'json_object'},
        },
      );

      return response.data;
    } on DioException catch (e) {
      // Handle specific Dio errors
      if (e.response != null) {
        throw Exception('API Error: ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }


    Future<String> callGroqAPI({
    required List<Map<String, String>> messages,
    String model = 'llama-3.1-8b-instant',
    double temperature = 1.0,
    int maxTokens = 1024,
  }) async {
    try {
      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
        ),
        data: {
          'messages': messages,
          'model': model,
          'temperature': temperature,
          'max_tokens': maxTokens,
          'top_p': 1,
          'stream': false,
          'stop': null
        },
      );

      return response.data['choices'][0]['message']['content'];
    } on DioException catch (e) {
      print('Groq API Error: ${e.response?.data ?? e.message}');
      throw Exception('Failed to call Groq API');
    }
  }
}



class OpenAIService {
  
  final Dio _dio = Dio();
  final String _apiKey = '';



 

  Future<String> callOpenAIAPI(String assistantPrompt) async {
    try {
      final response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
        ),
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': assistantPrompt}
          ],
          'max_tokens': 150
        },
      );

      return response.data['choices'][0]['message']['content'].trim();
    } on DioException catch (e) {
      print('API Error: ${e.response?.data ?? e.message}');
      throw Exception('Failed to call OpenAI API');
    }
  }
}




class GeminiApiService {
  final Dio _dio = Dio();
  final String apiKey;

  GeminiApiService(this.apiKey);
Future<String> askBot({
  
    required String prompt,
  }) async {
    try {
      // Step 1: Upload the file
     
      // Step 2: Prepare the API request payload    
      //
      var chatCtr=Get.find<ChatController>();
      
      final payload = {
        "contents":chatCtr.finalMessages, 
        "safetySettings": [
                {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
            ],
            "systemInstruction": {
    "role": "user",
    "parts": [
      {
        "text": "As an health assistant answer user with reference to  user  data=${Get.find<Usercontroller>().userHealthData}.Todays calorie consuption dat if user=${Get.find<ChatController>().todaysdata}  .Dont add unnecessary extra text or dont tell to consult any doctor .Dont answer anything else except health/food /nutrition and excersise"
      }
    ]
  },
        "generationConfig": {
          "temperature": 0.5,
          "topK": 40,
          "topP": 0.95,
    "responseMimeType": "text/plain"
        }
      };


      developer.log(payload.toString(), name: 'MyApp'); //
     

      // Step 3: Make the API call
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
        data: payload,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
 debugPrint(response.data.toString());
      // Step 4: Parse and return the response
      return 
        response.data['candidates'][0]['content']['parts'][0]['text'].toString();
      

    } catch (e) {
      print('Error in nutrition analysis: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> analyzeNutrition({
    required File imageFile,
    required String prompt,
  }) async {
    try {
      // Step 1: Upload the file
      print("imamge=${imageFile.path}");
      String fileUri = await _uploadFile(imageFile);
    print("file.path=${imageFile.path}");
      // Step 2: Prepare the API request payload    
      //
      var chatCtr=Get.find<ChatController>();
      chatCtr.currentUri= fileUri;      
      final payload = {
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "fileData": {
                  "fileUri": fileUri,
                  "mimeType": "image/webp", // Optional but recommended

             
                }
              },        
              {   
                "text":json.encode(prompt)
                
              
              }
            ]
          }
        ], "safetySettings": [
                {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
            ],
        "generationConfig": {
          "temperature": 1,
          "topK": 40,
          "topP": 0.95,
          // "maxOutputTokens": 8192,
          "responseMimeType": "application/json"    
        }
      };

      debugPrint(payload.toString());

      // Step 3: Make the API call
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
        data: payload,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
 debugPrint(response.data.toString());
      // Step 4: Parse and return the response
      final nutritionData = json.decode(
        response.data['candidates'][0]['content']['parts'][0]['text']
      );

      return nutritionData;
    } catch (e) {
      print('Error in nutrition analysis: $e');
      rethrow;
    }
  }

  Future<String> _uploadFile(File file) async {
    try {
      // Get file size
      int fileSize = await file.length();
 final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      // Prepare upload request
      final uploadResponse = await _dio.post(
        'https://generativelanguage.googleapis.com/upload/v1beta/files?key=$apiKey',
        data: file.readAsBytesSync(),
        options: Options(
          headers: {
            'X-Goog-Upload-Command': 'start, upload, finalize',
            'X-Goog-Upload-Header-Content-Length': fileSize,
           
               'X-Goog-Upload-Header-Content-Type': 'image/webp',
            'Content-Type': 'image/webp'
          },
        ),
      );
     
      // Extract and return file URI
      return uploadResponse.data['file']['uri'];
    } catch (e) {
      print('File upload error: $e');
      rethrow;
    }
  }
}
