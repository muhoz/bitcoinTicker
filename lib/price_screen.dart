import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

var bitcoinAverage =
    Uri.parse("https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD");

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedValue = 'USD';
  int selectedV = 0;
  var currentCoin;
  var curVal;
  var t;

  Future<dynamic> getBTCUSD(String c) async {
    var response = await http.get(Uri.parse(
        "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC$c"));
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        t = jsonDecode(response.body)["last"];
      });
      //print(t);
    } else {
      print(response.statusCode);
      if(response.statusCode == 403){
        alertError(context);
      }
      t = 0;
      //print(t);
    }
    return t;
  }

  List<DropdownMenuItem<String>> getCurrencies() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String a in currenciesList) {
      var p = DropdownMenuItem(
        child: Text(a),
        value: a,
      );
      dropDownItems.add(p);
    }
    return dropDownItems;
  }

  List<Text> getCurrencies2() {
    List<Text> dropDownItems = [];
    for (String i in currenciesList) {
      var p = Text(i);
      dropDownItems.add(p);
    }
    return dropDownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top : 8.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('🤑  Coin Ticker',style: GoogleFonts.macondo(textStyle : TextStyle(fontSize: 30,letterSpacing: 3),),),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height/10,),
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" 1",style: GoogleFonts.macondo(textStyle : TextStyle(fontWeight: FontWeight.bold,fontSize: 55.0,
                        color: Colors.lightGreenAccent,),),),
                      Text(
                        ' BTC = ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.macondo(
                          textStyle : TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),)
                      ),
                      Text(" $t",style: GoogleFonts.macondo(textStyle : TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0,
                        color: Colors.indigo,),),),
                      Text(" $selectedValue",style: GoogleFonts.macondo(textStyle : TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0,
                        color: Colors.white54,),)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: DropdownButton<String>(
                dropdownColor: Colors.black54,
                value: selectedValue,
                borderRadius: BorderRadius.circular(15),
                style: GoogleFonts.macondo(textStyle: TextStyle(fontSize: 30,)),
                items: getCurrencies(),
                menuMaxHeight: 400,
                onChanged: (value) {
                  setState(() {
                    print(value);
                    selectedValue = value.toString();
                    getBTCUSD(selectedValue);
                  });
                },
              ),
              /*
CupertinoPicker(
itemExtent: 32.0,
onSelectedItemChanged: (value) {
setState(() {
print(value);
selectedV = value;
currentCoin = currenciesList[selectedV];
print(currentCoin);
getBTCUSD(currentCoin);
});
},
children: getCurrencies2(),
),*/
            ),
          ],
        ),
      ),
    );
  }
}

//

/*
CupertinoPicker(
itemExtent: 32.0,
onSelectedItemChanged: (value) {
setState(() {
print(value);
selectedV = value;
currentCoin = currenciesList[selectedV];
print(currentCoin);
getBTCUSD(currentCoin);
});
},
children: getCurrencies2(),
),*/

void alertError(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          title: Text(
            "Impossible d'éxecuter la requête pour l'instant, veuillez réessayer plus tard",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shadowColor: Colors.lightBlueAccent,
                primary: Colors.blue,
                textStyle: GoogleFonts.macondo(textStyle:TextStyle(
                  fontWeight: FontWeight.bold,
                ),)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Okay",
              ),
            )
          ],
        );
      }
  );}