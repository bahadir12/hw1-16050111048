import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
final playerPointsToAdd = ValueNotifier<int>(2);
final lvlUpdate = ValueNotifier<int>(0);
final hightScore=ValueNotifier<int>(0);
int maxNumber2;
class abc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(   title: Text("Welcome Find Animal Game "),),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          RaisedButton(child:Text("Find Animal"),color: Colors.blue,onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Oyun()),);
          hightScore.value=0;
          })
        ],
      ),
    )
    );
  }

  }
class Animal{
  String _name;
  String _image;
  String _sound;

  String get sound => _sound;

  set sound(String value) {
    _sound = value;
  }

  Animal(this._name, this._image, this._sound);

  String get image => _image;

  String get name => _name;

  set image(String value) {
    _image = value;
  }

  set name(String value) {
    _name = value;
  }
}
AudioCache cache = AudioCache();
AudioPlayer player=AudioPlayer();
class Oyun extends StatefulWidget{

  @override
  _OyunState createState() => _OyunState();
}

class _OyunState extends State<Oyun> {
  FlutterTts flutterTts=FlutterTts();
  @override
  List<Animal> allAnimal;
  @override
  Widget build(BuildContext context) {
    readFromLocal();
    if(maxNumber2==null){
      maxNumber2=0;
    }

     allAnimal=allanimal();
     return WillPopScope(

       // ignore: missing_return
       onWillPop: (){
         lvlUpdate.value=0;
         Navigator.pop(context);
         stopSound();
         playerPointsToAdd.value=2;
       },
       child: Scaffold(
         appBar: AppBar(title: Text("Max Score:"+maxNumber2.toString() , style: TextStyle(color: Colors.white),),),
         body: listAnimal(context),

       ),
     );


  }

  List<Animal> allanimal() {
    var animalName=["bee","cat","chicken","cow","crocodile","donkey","duck","frog","giraffe","hawk","horse","lamb","lion","monkey","monkseal","pig","rabbit","rooster","snake","wolf"];
    List<Animal> animal=[];
    for(int i=0;i<20;i++){
    String image=animalName[i]+".jpg";
    String name=animalName[i];
    String sound=animalName[i]+".wav";
    Animal newAnimal=Animal(name,image,sound);
    animal.add(newAnimal);
    }
return animal;
  }

 Widget listAnimal(context) {
   List<Animal> randomAnimal=[];
   var randomHappylist;
   var soundAnimalName;
   int randomNumber;
   for(var i=0;i<playerPointsToAdd.value;i++){

     randomHappylist  = (allAnimal.toList()..shuffle()).first;
     allAnimal.remove(randomHappylist);
     randomAnimal.add(randomHappylist);
     if(i==0){
       var rng = new Random();
       randomNumber=rng.nextInt(playerPointsToAdd.value);
     }
     if(i==randomNumber){
       soundAnimalName=randomHappylist.name;
       _speak(soundAnimalName);
       playSoundAnimal(randomHappylist.sound);
     }
   }

    return GridView.count(crossAxisCount: 2,children: randomAnimal.map((animal){
      return InkWell(
        onTap: () {
          if(animal.name==soundAnimalName){
            if(lvlUpdate.value==2){
              lvlUpdate.value=0;
              if(playerPointsToAdd.value==5){
                hightScore.value+=10;
                stopSound();
                playerPointsToAdd.value=2;
                Navigator.pop(context);
                readFromLocal();
              }
              else{
                _trueAnswer();
                sleep(Duration(seconds:1));
                hightScore.value+=10;
                stopSound();
                setState(() {
                  playerPointsToAdd.value++;
                });
              }
            }

            else{
              setState(() {
                _trueAnswer();
                sleep(Duration(seconds:1));
                hightScore.value+=10;
                stopSound();
                lvlUpdate.value++;
              });
            }
          }

          else{
            _wrongAnswer();
            stopSound();
            playerPointsToAdd.value=2;
            Navigator.pop(context);
              if(hightScore.value>maxNumber2){
                lvlUpdate.value=0;
                readFromLocal();
              }
              else{
                hightScore.value=0;
                lvlUpdate.value=0;
              }
          }
        },

        child:  Hero(tag: Image.asset("images/"+animal.image, width: 100,height: 100,),child: Card(
          elevation: 3,
          child: Column(
            children: <Widget>[
              Container(
                width: 100,
                height: 180,
                child: Image.asset("images/"+animal.image, width: 100,height: 100,),
              ),
              Text(animal.name)
            ],
          ),
        ),),
      );
    }).toList(),);
  }

  Widget oneCardAnimal(BuildContext context, int index) {
    Animal insertData=allAnimal[index];
    return Container(
      height: 100,
      child: Card(
      elevation: 4,
      child: ListTile(
        leading: Image.asset("images/"+insertData.image, width: 100,height: 100,),
        title: Text(insertData.name,),
        trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink),

      ),
    ),
    );
  }

playSoundAnimal(randomHappylist) async{
  player=await cache.play('$randomHappylist');

}
 stopSound() async{
    await player.dispose();
}
  readFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    maxNumber2 = prefs.getInt('maxNumber42') ?? 0 ;
   if(hightScore.value>maxNumber2){
     print("ssssssss");
     print(hightScore.value);
     prefs.setInt('maxNumber42', hightScore.value);
   }
  }
  Future _speak(soundAnimalName) async {
    await flutterTts.speak("Find the "+soundAnimalName);
  }
  Future _trueAnswer() async {
    await flutterTts.speak("You got it ");
  }
  Future _wrongAnswer() async {
    await flutterTts.speak("Wrong Answer");
  }
}

