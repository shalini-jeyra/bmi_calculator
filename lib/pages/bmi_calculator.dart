import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task/services/api_service.dart';

import '../model/user.dart';

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  TextEditingController nameController=TextEditingController();
TextEditingController heightController=TextEditingController();
TextEditingController weightController=TextEditingController();
  //weight/height*2

  double result=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
title: const Text('Bmi calculator'),
actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ProfileWidget(),),);
              },
            ),
          ],
      ),
      body:  SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
           TextField(
            controller: nameController,
      onChanged: (val){

      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
      
        hintText: 'Name',
        
      )
    
          ),
          const SizedBox(height:20),
          TextField(
            controller: heightController,
      onChanged: (val){

      },
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
      
        hintText: 'Height',
        
      )
    
          ),
          const SizedBox(height:20),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            onChanged: (val){},
            decoration:const InputDecoration(
              hintText:'Weight'
            )
          ),
      const SizedBox(height:20),
    ElevatedButton(
      
      onPressed: ()async{
var box=await Hive.openBox<User>('users');
      // result=double.parse(weightController.text)/(double.parse(heightController.text)*2);
  User user=User(height: heightController.text,weight: weightController.text,name: nameController.text);
  await box.put(nameController.text,user);

   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ResultPage(name: nameController.text,),),);
    }, child: const Text('Submit'))



        ]),
      ),

      ) ,
    );
  }
}




class ResultPage extends StatefulWidget {
  const ResultPage({super.key,required this.name});
final String name;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
   late Box<User> _userBox;
  late User _user;
 double result=0;
  @override
  void initState() {
   
    // TODO: implement initState
    super.initState();
_userBox = Hive.box<User>('users');
    _user = _userBox.values.firstWhere(
      (user) => user.name == widget.name,
      orElse: () => User(name: '', height: '',weight: '' ));
    result=double.parse(_user.weight)/(double.parse(_user.height)*2);
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Card(
child: Center(child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
     Text('The Result of ${_user.name} is',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        Text(result.toString()),
  ],
)),

      ),
    )),);
  }
}




class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

 

 

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder(
        future: ApiService().getService(),
        builder: (context,snap) {
           if(snap.data!=null){
          return Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(snap.data[0]['picture']['large']),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Name: ${snap.data[0]['name']['title']} ${snap.data[0]['name']['first']} ${snap.data[0]['name']['last']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Gender: ${snap.data[0]['gender']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Email: ${snap.data[0]['email']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Location: ${snap.data[0]['location']['city']}, ${snap.data[0]['location']['country']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
           }
           return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
