import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'constant.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

///
///On this interactive page, a welcome page will appear with a button that moves it to Chat bot
///

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //insert image and fix size-----------------------------------------------------
          Image(
            image: AssetImage(
              "assets/WelcomePage.jpg",
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          //insert title also play whit size and color-----------------------------------------------------
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 550),
            child: Column(
              children: [
                Text(" مرحبا بك في رُوشِتّة ",
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Color(0xff404551),
                          fontWeight: FontWeight.bold,
                        )),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 650),
            child: Column(
              children: [
                Text("المكان الذي يجتمع الطب والتقنية",
                    style: TextStyle(color: Color(0xff404551), fontSize: 20)),
              ],
            ),
          ),
          Container(
            //create button-----------------------------------------------------
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 600,
            ),
            child: ElevatedButton(
              child: Text("حدثني",
                  style: TextStyle(
                    color: Color(0xffF9F8FD),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(134, 50),
                primary: Color(0xff404551),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              //call the Second page
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage()));
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 830),
            child: Column(
              children: [
                Text("بيان اخلاء المسؤولية",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 5, 77, 244),
                        fontSize: 17)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// #############################################################################
const backgroundColor = Color(0xff757B8E);
const botBackgroundColor = Color(0xff404551);

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late bool isLooading;
  TextEditingController _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLooading = false;
  }

  Future generateResponse(List<ChatMessage> messages) async {
//===========================================================
//API function
    var url =
        Uri.https("experimental.willow.vectara.io", "/v1/chat/completions");
    final List<Map<String, dynamic>> someBody = messages.map((message) {
      return {"role": "user", "content": message.text.toString()};
    }).toList();
    ;
    log(someBody.length.toString());
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "x-api-key": apiSecretKey,
        "customer-id": "1735240579"
      },
      body: json.encode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": '''اهذه معلومات المستخدم اللذي سوف يتواصل معك: /n 
                اإلسم: رشا شفاء
العمر: ٣٠ سنة
الجنس: أنثى
الطول: ١٦٥ سم
الوزن: ٨٠ كجم
الحالة الصحية: حامل في الشهر الثامن
                ''',
            },
            {
              "role": "system",
              "content":
                  "اذا سأل المستخدم عن اسمه اذكر الاسم فقط ولا تذكر جملة حسب المعلومات المذكورة في البداية"
            },
            {
              "role": "system",
              "content":
                  "اذا سأل المستخدم عن اسمه اذكر الاسم فقط ولا تذكر جملة كما ورد في المعلومات المذكورة في البداية"
            },
            {
              "role": "system",
              "content": "يجب مراعاة حالة المستخدم الطبية قبل اقتراح اي ادوية"
            },
            {
              "role": "system",
              "content": "اذا سأل المستخدم عن اسم التجاري للدواء اذكر الاسم فقط"
            },
            {
              "role": "system",
              "content": '''
 استخدم هذه المعلومات عن الادوية اذا المستخدم سألك عن احد منها ، اختصر في الاجابة و لاتعطتي معلومات زايدة 
الاسم التجاري: فيفادول ٥٠٠ ملجم
1. الاسم العلمي: Paracetamol 
2. التركيز: ٥٠٠ مليغرام
3. دواعي الاستعمال:  مسكن للألم وخافض للحرارة، يخفف من التهابات الحلق، وينصح به للتخفيف من الألم.
4. موانع الإستخدام: رد فعل تحسسي من مادة الباراسيتامول، يجب توخي الحذر إذا كان المستخدم لديه أمراض كبد أو كلى.
5. الحمل والرضاعة: يمكن تناول الدواء أثناء الحمل والرضاعة.



الأسم التجاري: اي- بروفين ٤٠٠ ملجم
1. الاسم العلمي: Ibuprofen
2. التركيز: ٤٠٠ ملجم
3. دواعي الاستعمال: مسكن للألم وخافض للحرارة، يخفف من التهابات الحلق، وينصح به للتخفيف من الألم.
4. موانع الإستخدام: مسكن للألم وخافض للحرارة ومضاد للالتهاب، يستخدم لعلاج الآلام والالتهابات.
5. الحمل والرضاعة: يجب تجنب استخدام Ibuprofen اذا كنت حامل او مرضع.


الأسم الشعبي: عين الديك, أو عصبة السوس, أو عين العفريت 
1. يجب تجنب اي خلطات شعبية تحتوي على هذة النبته لأنها تسبب إجهاض الجنين
2. يجب على الحوامل والمرضعات تجنب اخذ أي ادوية أو خلطات شعبية حتى تستشير الطبيب المختص

الأسم الشعبي: المر أو المرة
1. يجب على الحامل تجنب المرة لأنها تسبب إجهاض الجنين
2. يجب على الحوامل والمرضعات تجنب اخذ أي ادوية أو خلطات شعبية حتى تستشير الطبيب المختص
''',
            },
            ...someBody,
          ],
        },
      ),
    );
    final jsonRes = jsonDecode(response.body);
    final gptResponse = jsonRes['choices'][0]['message']['content'];
    log(gptResponse.toString());
    return gptResponse;
  }

//=======================================================
//تصميم الصفحة
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 60,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "اسأل روشِتّة",
              maxLines: 2,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          backgroundColor: botBackgroundColor,
        ),
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            //chat body
            Expanded(
              child: _buildList(),
            ),

            //هنا شعار التحميل
            Visibility(
              visible: isLooading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //input field(مساحة المدخلات)
                  _buildInput(),
                  //submit button(زر الارسال)
                  _buildSubmit(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
        child: TextField(
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: Colors.white, fontSize: 19),
      //retreve the input value
      controller: _textController,
      decoration: InputDecoration(
        fillColor: botBackgroundColor,
        filled: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    ));
  }

  Widget _buildSubmit() {
    return Visibility(
      //اللودنق هنا يطلع بعد ما ارسل
      visible: !isLooading,
      child: Container(
        color: botBackgroundColor,
        child: IconButton(
          icon: Icon(
            Icons.send_rounded,
            color: Colors.white,
            // Color.fromRGBO(142, 142, 160, 1),
          ),
          onPressed: () async {
            setState(
              () {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLooading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            await generateResponse(_messages).then((value) {
              setState(() {
                isLooading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
          },
        ),
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: _messages.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot
          ? botBackgroundColor
          : backgroundColor,
      child: Row(children: [
        chatMessageType == ChatMessageType.bot
            ? Container(
                margin: EdgeInsets.only(right: 16),
                child: CircleAvatar(
                    backgroundColor: Color(0xff404551),
                    child: Image.asset(
                      "assets/Chatbot.png",
                      color: Colors.white,
                    )),
              )
            : Container(
                margin: EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Color(0xff757B8E),
                  child: Image.asset(
                    "assets/UserCircle.png",
                    color: Colors.white,
                  ),
                ),
              ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ))
      ]),
    );
  }
}
