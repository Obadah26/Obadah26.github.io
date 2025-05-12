import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});
  static String id = 'azkar_screen';
  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  final Map<String, Map<String, dynamic>> azkarAsbah = {
    'آية الكرسي': {
      'النص':
          'الله لا إله إلا هو الحي القيوم لا تأخذه سنة ولا نوم له ما في السماوات وما في الأرض من ذا الذي يشفع عنده إلا بإذنه يعلم ما بين أيديهم وما خلفهم ولا يحيطون بشيء من علمه إلا بما شاء وسع كرسيه السماوات والأرض ولا يؤوده حفظهما وهو العلي العظيم. [آية الكرسى - البقرة 255]',
      'عدد التكرارات': 1,
    },
    'سورة الإخلاص': {
      'النص':
          'بسم الله الرحمن الرحيم\nقل هو الله أحد، الله الصمد، لم يلد ولم يولد، ولم يكن لهۥ كفوا أحدۢ.',
      'عدد التكرارات': 3,
    },
    'سورة الفلق': {
      'النص':
          'بسم الله الرحمن الرحيم\nقل أعوذ برب الفلق، من شر ما خلق، ومن شر غاسق إذا وقب، ومن شر النفثت فى العقد، ومن شر حاسد إذا حسد.',
      'عدد التكرارات': 3,
    },
    'سورة الناس': {
      'النص':
          'بسم الله الرحمن الرحيم\nقل أعوذ برب الناس، ملك الناس، إله الناس، من شر الوسواس الخناس، الذى يوسوس فى صدور الناس، من الجنة والناس.',
      'عدد التكرارات': 3,
    },
    'الحديث رقم 1': {
      'النص':
          'أصبحنا وأصبح الملك لله والحمد لله ، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير ، رب أسألك خير ما في هذا اليوم وخير ما بعده ، وأعوذ بك من شر ما في هذا اليوم وشر ما بعده، رب أعوذبك من الكسل وسوء الكبر ، رب أعوذ بك من عذاب في النار وعذاب في القبر.',
      'عدد التكرارات': 1,
    },
    'الحديث رقم 2': {
      'النص':
          'اللهم أنت ربي لا إله إلا أنت ، خلقتني وأنا عبدك ، وأنا على عهدك ووعدك ما استطعت ، أعوذبك من شر ما صنعت ، أبوء لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت .',
      'عدد التكرارات': 1,
    },
    'الحديث رقم 3': {
      'النص': 'رضيت بالله ربا وبالإسلام دينا وبمحمد صلى الله عليه وسلم نبيا.',
      'عدد التكرارات': 3,
    },
    'الحديث رقم 4': {
      'النص':
          'اللهم إني أصبحت أشهدك ، وأشهد حملة عرشك ، وملائكتك ، وجميع خلقك ، أنك أنت الله لا إله إلا أنت وحدك لا شريك لك ، وأن  محمدا عبدك ورسولك.',
      'عدد التكرارات': 4,
    },
    'الحديث رقم 5': {
      'النص':
          'اللهم إني أصبحت أشهدك ، وأشهد حملة عرشك ، وملائكتك ، وجميع خلقك ، أنك أنت الله لا إله إلا أنت وحدك لا شريك لك ، وأن  محمدا عبدك ورسولك.',
      'عدد التكرارات': 1,
    },
    'الحديث رقم 6': {
      'النص': 'حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم.',
      'عدد التكرارات': 7,
    },
    'الحديث رقم 7': {
      'النص':
          'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم.',
      'عدد التكرارات': 3,
    },
    'الحديث رقم 8': {
      'النص': 'اللهم بك أصبحنا وبك أمسينا ، وبك نحيا وبك نحيا وإليك النشور.',
      'عدد التكرارات': 1,
    },
  };

  int _currentIndex = 0;

  void _nextZikr() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % azkarAsbah.length;
    });
  }

  void _beforeZikr() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % azkarAsbah.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = azkarAsbah.keys.elementAt(_currentIndex);
    String text = azkarAsbah[title]?['النص'] ?? '';
    int repeats = azkarAsbah[title]?['عدد التكرارات'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, HomeScreen.id);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 50,
                color: kLightPrimaryColor,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'أذكار الصباح',
                  style: GoogleFonts.elMessiri(textStyle: kHeading1Text),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kSecondaryColor, width: 2),
                ),
                constraints: BoxConstraints(maxWidth: 350, minWidth: 200),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          title,
                          style: GoogleFonts.cairo(
                            textStyle: kHeading2Text,
                            color: kLightPrimaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          text,
                          style: GoogleFonts.cairo(
                            textStyle: kBodyLargeText.copyWith(fontSize: 25),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'عدد التكرارات: $repeats',
                          style: GoogleFonts.cairo(textStyle: kBodyRegularText),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kSecondaryColor, width: 2),
                      ),
                      child: IconButton(
                        onPressed: _beforeZikr,
                        icon: Icon(Icons.arrow_back, color: kLightPrimaryColor),
                      ),
                    ),
                    SizedBox(width: 75),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kSecondaryColor, width: 2),
                      ),
                      child: IconButton(
                        onPressed: _nextZikr,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: kLightPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
