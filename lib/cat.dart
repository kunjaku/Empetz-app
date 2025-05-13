// import 'package:flutter/material.dart';

// class Cat extends StatefulWidget {
//   const Cat({super.key});

//   @override
//   State<Cat> createState() => _CatState();
// }

// class _CatState extends State<Cat> {
//   List name = ["junaid", "Ahmed", "Aqib", "Zaid", "Sohail"];
//   List price = ["5000", "10000", "15000", "3000", "4000"];
//   List net = [
//     "https://www.thesprucepets.com/thmb/Wy9Vno45XeFtos7omJ80qkZrtZc=/3760x0/filters:no_upscale():strip_icc()/GettyImages-174770333-0f52afc06a024c478fafb1280c1f491f.jpg",
//     "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/640px-Cat03.jpg",
//     "https://d2zp5xs5cp8zlg.cloudfront.net/image-29951-800.jpg",
//     "https://www.purina.in/sites/default/files/2020-11/8-Fluffy-Cat-BreedsTEASER.jpg",
//     "https://www.rossmorevethospital.com.au/wp-content/uploads/2022/08/golden-baby-cat.jpeg"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//        backgroundColor: Colors.amber,
//         title: Text(
//           "Cat",
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: ListView.builder(
//           itemCount: 5,
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
//               child: Card(
//                 color: const Color.fromARGB(255, 226, 213, 213),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: NetworkImage(net[index]),
//                   ),
//                   trailing:
//                       IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
//                   title: Text(name[index]),
//                   subtitle: Text(price[index]),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
