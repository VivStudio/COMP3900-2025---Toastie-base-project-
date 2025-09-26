import 'package:flutter/material.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/features/lab_report/add_report.dart';
import 'package:toastie/utils/grid.dart';

class AddLabReportScreen extends StatefulWidget {
  AddLabReportScreen({
    required this.date,
  });

  final DateTime date;

  @override
  State<AddLabReportScreen> createState() => _AddLabReportScreenState();
}

class _AddLabReportScreenState extends State<AddLabReportScreen> {
  @override
  void initState() {
    super.initState();
  }

  _navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderTitleWithBackButton(
              title: 'Add report',
              backButtonClicked: () => _navigateBack(context),
            ),
            AddReport(),
            SizedBox(height: gridbaseline),
          ],
        ),
      ),
    );
  }
}
