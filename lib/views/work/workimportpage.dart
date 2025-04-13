// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:workflow/providers/work_provider.dart';
// import 'package:workflow/widget/mybutton.dart';
// import 'package:workflow/widget/mydropdownbutton.dart';
// import 'package:workflow/widget/mymainlayout/mainlayout.dart';
// import 'package:workflow/widget/mymainlayout/myappbar.dart';
// import 'package:workflow/widget/mytextfield.dart';
// import '../../models/Work.dart';

// class WorkImportPage extends StatefulWidget {
//   const WorkImportPage({super.key});

//   @override
//   State<WorkImportPage> createState() => _WorkImportPageState();
// }

// class _WorkImportPageState extends State<WorkImportPage> {
//   List<List<String>> list = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Import taks')),
//       body: MainLayout(
//         actions: [
//           MyButton(
//             child: Text('Import'),
//             onPressed: () async {
//               list = await importExcel();
//               setState(() {});
//             },
//           ),
//           MyButton(
//             child: Text('Push'),
//             onPressed: () async {
//               List<Work> works = [];
//               for (var i = 0; i < list.length; i++) {
//                 works.add(
//                   Work(taskId: null, createBy: '', info: ''

//                   ),
//                 );
//               }
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     actions: [
//                       MyButton(
//                         child: Text('Close'),
//                         onPressed: () async {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ],
//                     title: Text('Push users to server'),
//                     content: PushProgressWidget(
//                       onFinish: () {},
//                       items: works,
//                       onPush: (item) async {
//                         return context.read<WorkProvider>().createWork(item);
//                       },
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//         child: MyTable(
//           columnWidths: {0: 50},
//           data: list,
//           header: ["id", "title", "description", "point", "WorkTime", "type"],
//         ),
//       ),
//     );
//   }
// }
