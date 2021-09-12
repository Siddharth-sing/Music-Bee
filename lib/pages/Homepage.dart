import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_bee/model/radio.dart';
import 'package:music_bee/utils/aiUtils.dart';
import 'package:velocity_x/velocity_x.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<MyRadio> radios = [];
  MyRadio _selectedRadio;
  Color _selectedColor;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUpAlan();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  setUpAlan(){
    AlanVoice.addButton(
        "abe5509444db4ff9bd0af2a9d4f3bb612e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command)  {
         _handleCommand(command.data);
    });
  }
  _handleCommand(Map<String, dynamic> response){
        switch(response["command"])
        {
          case "play":
            _playMusic(_selectedRadio.url);
          break;
          default: print("Default");
          break;
        }
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("asset/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios[0];
    _selectedColor = Color(int.tryParse(_selectedRadio.color));
    print(radios);
    setState(() {});
  }
  _playMusic(String url) {

    _audioPlayer.play(url);
     _selectedRadio = radios.firstWhere((element) {
      return element.url == url;
    });
    print(_selectedRadio.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: <Widget>[
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
            LinearGradient(
              colors: [
                Colors.orange,
                _selectedColor ,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ).make(),
          AppBar(
            title: Text(
              'AI Radio',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 28,
              ),
            ).shimmer(
              primaryColor: Vx.purple300,
              secondaryColor: Colors.white,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
         radios!=null?VxSwiper.builder(
            itemCount: radios.length,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
            onPageChanged: (index){
              final color = radios[index].color;
              setState(() {
                _selectedColor = Color(int.tryParse(color));
              });

            } ,
            itemBuilder: (context, index) {
              final rad = radios[index];
              return VxBox(
                child: ZStack(
                  [
                    Align(
                      alignment: Alignment.topRight,
                      child:Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 35, 0) ,
                        child: Text(
                          "${rad.category}".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0,0,0,10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${rad.name}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "${rad.tagline}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment:Alignment.center,
                      child: Icon(
                        CupertinoIcons.play_circle,
                        color: Colors.white.withOpacity(0.7),
                        size: 70,
                      ),
                    ),
                  ],
                ),
              ).bgImage(
                DecorationImage(
                  image: NetworkImage(rad.image),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ).border(color: Colors.black, width: 5.0)
                  .withRounded(value: 60.0)
                  .make()
                  .onInkDoubleTap(() {
                    _playMusic(rad.url);
                  })
                  .p16()
                  .centered();
              },
         ):Center(
           child: CircularProgressIndicator(),
         ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - ${_selectedRadio.name} FM"
                    .text
                    .white
                    .makeCentered(),
              Icon(
                _isPlaying
                    ? CupertinoIcons.stop_circle
                    : CupertinoIcons.play_circle,
                color: Colors.white,
                size: 50.0,
              ).onInkTap(() {
                if (_isPlaying) {
                  _audioPlayer.stop();
                } else {
                  _playMusic(_selectedRadio.url);
                }
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
