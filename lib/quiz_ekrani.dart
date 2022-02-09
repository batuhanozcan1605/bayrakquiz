import 'dart:collection';

import 'package:bayrakquiz/Bayraklar.dart';
import 'package:bayrakquiz/Bayraklardao.dart';
import 'package:bayrakquiz/sonuc_ekrani.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizEkrani extends StatefulWidget {
  const QuizEkrani({Key? key}) : super(key: key);

  @override
  _QuizEkraniState createState() => _QuizEkraniState();
}

class _QuizEkraniState extends State<QuizEkrani> {

  var sorular = <Bayraklar>[];
  var yanlisSecenekler = <Bayraklar>[];
  late Bayraklar dogruSoru;
  var tumSecenekler = HashSet<Bayraklar>();

  int soruSayac = 0;
  int dogruSayac = 0;
  int yanlisSayac = 0;

  String bayrakresimAdi = "placeholder.png";
  String butonAyazi = "";
  String butonByazi = "";
  String butonCyazi = "";
  String butonDyazi = "";

  @override
  void initState() {
    super.initState();
    sorulariAl();
  }

  Future<void> sorulariAl() async {
    sorular = await Bayraklardao().rasgele5getir();
    soruYukle();
  }

  Future<void> soruYukle() async {
    dogruSoru = sorular[soruSayac];

    bayrakresimAdi = dogruSoru.bayrak_resim;

    yanlisSecenekler = await Bayraklardao().rasgele3YanlisGetir(dogruSoru.bayrak_id);

    tumSecenekler.clear();
    tumSecenekler.add(dogruSoru);
    tumSecenekler.add(yanlisSecenekler[0]);
    tumSecenekler.add(yanlisSecenekler[1]);
    tumSecenekler.add(yanlisSecenekler[2]);

    butonAyazi = tumSecenekler.elementAt(0).bayrak_ad;
    butonByazi = tumSecenekler.elementAt(1).bayrak_ad;
    butonCyazi = tumSecenekler.elementAt(2).bayrak_ad;
    butonDyazi = tumSecenekler.elementAt(3).bayrak_ad;

    print(butonAyazi);

    setState(() {
    });
  }

  void soruSayacKontrol() {

    soruSayac = soruSayac + 1;
    if(soruSayac != 5){
      soruYukle();
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SonucEkrani(dogruSayisi: dogruSayac,)));
    }
  }

  void dogruKontrol(String buttonYazi) {
    if(dogruSoru.bayrak_ad == buttonYazi){
      dogruSayac = dogruSayac + 1;
    }else{
      yanlisSayac = yanlisSayac+ 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Ekranı"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Doğru : $dogruSayac", style: TextStyle(fontSize: 18,),),
                  Text("Yanlış : $yanlisSayac", style: TextStyle(fontSize: 18,),),
                ],
              ),
              soruSayac != 5 ? Text("${soruSayac+1}. Soru", style: TextStyle(fontSize: 30),) :
              Text("5. Soru", style: TextStyle(fontSize: 30),),
              SizedBox(
                  width: 200,
                  child: Image.asset("images/$bayrakresimAdi")),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(onPressed: (){
                  dogruKontrol(butonAyazi);
                  soruSayacKontrol();
                  print("A");
                },
                  child: Text(butonAyazi),),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(onPressed: (){
                  dogruKontrol(butonByazi);
                  soruSayacKontrol();
                },
                  child: Text(butonByazi),),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(onPressed: (){
                  dogruKontrol(butonCyazi);
                  soruSayacKontrol();
                },
                  child: Text(butonCyazi),),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(onPressed: (){
                  dogruKontrol(butonDyazi);
                  soruSayacKontrol();
                },
                  child: Text(butonDyazi),),
              ),
            ]
        ),
      ),
    );
  }
}
