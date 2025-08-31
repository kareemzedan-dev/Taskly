// import 'package:flutter/material.dart';

// class SocialLoginButton extends StatelessWidget {
//   final String label;
//   final String iconPath;
//   final VoidCallback onPressed;

//   const SocialLoginButton({
//     super.key,
//     required this.label,
//     required this.iconPath,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 56,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//               width: 1,
//               color: Colors.black.withValues(alpha: 0.85),
//             ),
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         onPressed: onPressed,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SvgPicture.asset(iconPath),
//             const SizedBox(width: 53),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
