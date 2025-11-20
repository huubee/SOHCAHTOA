import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trig_sct/src/features/calculator/application/calculator_provider.dart';
import 'package:trig_sct/src/localization/app_localizations.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final localizations = AppLocalizations.of(context)!;
    final buttonStyle = ElevatedButton.styleFrom(
      textStyle: Theme.of(context).textTheme.headlineMedium,
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(20),
    );

    final buttons = [
      'C', '+/-', '%', '/',
      '7', '8', '9', 'x',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', '.', '=', 
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.calculatorTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/calculator/history'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/noise.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Display
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      state.expression,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.result,
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Buttons
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.1, // Adjust for better button spacing
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                final buttonText = buttons[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () => ref.read(calculatorProvider.notifier).onButtonPressed(buttonText),
                    style: buttonStyle,
                    child: Text(buttonText),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
