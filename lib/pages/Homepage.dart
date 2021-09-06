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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRadios();
  }

  fetchRadios() async{
    final radioJson = await rootBundle.loadString("asset/radio.json");
    radios =  MyRadioList.fromJson(radioJson).radios;
    print(radios);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children:<Widget> [
          VxAnimatedBox()
            .size(context.screenWidth, context.screenHeight)
            .withGradient(
          LinearGradient(
            colors: [
              aiColors.primaryolor1,
              aiColors.primaryolor2,
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
          VxSwiper.builder(
              itemCount: radios.length,
              aspectRatio: 1.0,

            itemBuilder: (context,index) {
                final rad = radios[index];
                return VxBox(
                  child: ZStack(
                      [

                      ],
                  ),
                )
                    .bgImage(DecorationImage(image: NetworkImage(rad.image)))
                    .make();


                },
          ),
        ],
      ),
    );
  }
}
