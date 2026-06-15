// import 'package:flutter/material.dart';

// class ImagePuzzleView extends StatefulWidget {
//   const ImagePuzzleView({super.key});

//   @override
//   State<ImagePuzzleView> createState() => _ImagePuzzleViewState();
// }

// class _ImagePuzzleViewState extends State<ImagePuzzleView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF4A148C),
//               Color(0xFF7B1FA2),
//               Color(0xFFBA68C8),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.construction,
//                       color: Colors.white,
//                       size: 90,
//                     ),

//                     SizedBox(height: 20),

//                     Text(
//                       'En construcción',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 34,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     SizedBox(height: 12),

//                     Text(
//                       'Disponible próximamente',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Positioned(
//                 top: 16,
//                 left: 16,
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }