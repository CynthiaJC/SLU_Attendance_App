import 'package:flutter_test/flutter_test.dart';

import 'package:slu_attendance_app/main.dart';

void main() {
  testWidgets('App loads role selection screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('SLU Attendance App'), findsOneWidget);
    expect(find.text('I am a Coordinator'), findsOneWidget);
    expect(find.text('I am an Intern'), findsOneWidget);
  });
}
