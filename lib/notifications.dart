// import 'package:flutter/material.dart';

// class Notifications extends StatefulWidget {
//   const Notifications({super.key});

//   @override
//   State<Notifications> createState() => _dddState();
// }

// class _dddState extends State<Notifications> {
//   List name = ["Jhon", "Tesa", "Emma", "Jacob", "Henry", "Asher"];
//   List message = ["Hi", "Hi", "Hi", "Hi", "Hi", "Hi"];
//   List profile = [
//     "assets/jhon.jpg",
//     "assets/pic1.jpg",
//     "assets/pic2.jpg",
//     "assets/pic3.jpg",
//     "assets/pic4.jpg",
//     "assets/pic5.jpg"
//   ];
//   List Time = [
//     "12:10 pm",
//     "10:00 am",
//     "12:10 pm",
//     "6:00 pm",
//     "12:30 pm",
//     "2:10 pm"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Colors.amber,
//         title: Text(
//           "NOTIFICATIONS",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//           itemCount: 6,
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
//               child: Card(
//                 color: const Color.fromARGB(255, 226, 213, 213),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: AssetImage(profile[index]),
//                   ),
//                   trailing: Text(Time[index]),
//                   title: Text(name[index]),
//                   subtitle: Text(message[index]),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
