import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: blue,
          title: Text("About"),
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              // ini kaya bikin shape yang bisa di customize sisi nya
              clipper: CustomShapeClipper(),
              child: Container(
                height: 350,
                decoration: BoxDecoration(color: Color.fromRGBO(0, 149, 218, 1),),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                Image.asset('img/Qu+.png', width: 200, height: 200,),
                  SizedBox(height: 80,),
                  Text(
                    'Jangan sampai kamu melupakan acara penting dalam hidupmu, karena tidak semua acara dapat diputar kembali. Buat hidup kamu menjadi lebih teratur dengan menggunakan aplikasi Quinget+. Dengan Quinget+ kamu dapat mengatur kegiatan apa saja yang kamu atau temanmu rencanakan dengan lebih mudah.'
                        '\n\nDibuat oleh:\n'
                        '\nArnan Dwika Diasmara'
                        '\nNicholas Christianto'
                        '\nStephanie Nadia Carrisa\n',
                    style: TextStyle(fontSize: 16, ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 20),
              child:Text('Copyright \u00a9 2020 by Quinget\'s Team',),
            )
          ],
        )
    );
  }
}
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
