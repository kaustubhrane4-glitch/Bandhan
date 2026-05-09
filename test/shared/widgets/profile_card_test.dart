import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bandhan/shared/widgets/profile_card.dart';

void main() {
  testWidgets('ProfileCard displays correct information', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileCard(
            name: 'Test User',
            age: 25,
            city: 'Mumbai',
            profession: 'Engineer',
            aiScore: 90,
            isVerified: true,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify Name and Age
    expect(find.text('Test User, 25'), findsOneWidget);
    
    // Verify City and Profession
    expect(find.text('Engineer • Mumbai'), findsOneWidget);
    
    // Verify AI Score
    expect(find.text('90%'), findsOneWidget);
    
    // Verify Verified Badge
    expect(find.text('Verified'), findsOneWidget);
  });
}
