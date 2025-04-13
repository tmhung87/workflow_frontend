// import 'package:flutter/material.dart';
// import 'package:workflow/widget/mytable.dart';

// Future showSelectDialog({
//   required BuildContext context,
//   required int length,
//   required Widget? Function(BuildContext context, int index) itemBuilder,
// }) async {
//   final result = await showDialog(
//     context: context,
//     builder:
//         (context) => AlertDialog(
//           title: Text('Enter a value'),
//           content: SizedBox(
//             width: 500,
//             child: ,
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, null); // không trả về gì
//               },
//               child: Text('Back'),
//             ),
//           ],
//         ),
//   );
//   return result;
// }
// class DialogSearch extends StatefulWidget {
//   const DialogSearch({super.key, required this.length, required this. itemBuilder});
//   final int length;
//   final Widget? Function(BuildContext context, int index) itemBuilder;
//   @override
//   State<DialogSearch> createState() => _DialogSearchState();
// }

// class _DialogSearchState extends State<DialogSearch> {
//   final _queryController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return MyTable(header: header, data: data)
//   }
// }
