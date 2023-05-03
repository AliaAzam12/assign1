import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Info App',
      theme: ThemeData(
       
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Country Information'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 String selectLoc = "Malaysia";
 List<String> locList = ["Korea","Indonesia","United States","Thailand","Japan","Malaysia","Australia","Hong Kong",];
 String desc = "No Record";
 double sex_ratio=0.0;
 String currency = "";
 String capital ="";
 double population = 0.0;
 String region ="";
 String countryCode = "";
 String flagUrl="";
 

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
       
        title: Text(widget.title),
      ),
   
      body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
      child: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Country App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle:FontStyle.italic)
            ),
            const SizedBox(height: 30),
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
               child: DropdownButton(
                isExpanded: true,
                  itemHeight: 60,
                  value: selectLoc,
                  onChanged: (newValue){
                    setState(() {
                      selectLoc = newValue.toString();
                    });
                  },
                  items: locList.map((selectLoc){
                    return DropdownMenuItem(
                      value: selectLoc,
                      child: Text(
                        selectLoc, style: const TextStyle(color: Colors.black)
                      ),
                    );
                  }).toList(),
                ),
             ),
           ),
       
            ElevatedButton(onPressed: getInfo, child: const Text("Search")),

            if(flagUrl != "") ...[Image.network('https://www.flagsapi.com/$countryCode/shiny/64.png')],
            Text(desc, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.5, fontStyle: FontStyle.italic)),
            
          ],
       ),
        ),
      ),
    ),
    );
  }

  Future<void> getInfo()  async {
    ProgressDialog progressDialog = ProgressDialog(context, message: const Text("Loading"), title: const Text("Searching..."));
    progressDialog.show();


    Uri url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$selectLoc');
    var response = await http.get(url, headers: {'X-Api-Key': 'Vk0x9Hdf7toNhgFsH0nSUg==eCv9ivrwQ6WYh62F'});
    if(response.statusCode == 200){
      String jsonData = response.body;
      var parsedJson = json.decode(jsonData);

      if (parsedJson.isEmpty){
        setState(() {
          desc = "No such country is found.";
        });
      }else{

      setState(() {

      sex_ratio = parsedJson[0]['sex_ratio'];
      currency = parsedJson[0]['currency']['name'];
      capital = parsedJson[0]['capital'];
      population = parsedJson[0]['population'];
      region = parsedJson[0]['region'];
      countryCode = parsedJson[0]['iso2'];

      flagUrl = 'https://www.flagsapi.com/$countryCode/shiny/64.png';
      
      progressDialog.dismiss();

      desc = "\n- Capital: $capital\n- Population: $population\n- Currency: $currency\n- Sex ratio: $sex_ratio for every 100 females\n- Region: $region";
     });
      
        
    }
  }
}
}