import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trig_sct/src/features/calculator/application/calculator_state.dart';
import 'package:math_expressions/math_expressions.dart';

part 'calculator_provider.g.dart';

@riverpod
class Calculator extends _$Calculator {
  @override
  CalculatorState build() => const CalculatorState();

  void onButtonPressed(String buttonText) {
    var expression = state.expression;
    var result = state.result;
    var history = state.history;

    switch (buttonText) {
      case 'C':
        expression = '';
        result = '0';
        break;
      case 'Clear History':
        history = [];
        break;
      case '+':
      case '-':
      case 'x':
      case '/':
        if (result.endsWith('.')) {
          result = result.substring(0, result.length - 1);
        }
        if (expression.isNotEmpty && ['+', '-', 'x', '/'].contains(expression[expression.length - 1])) {
            expression = expression.substring(0, expression.length - 1) + buttonText;
        } else {
            expression += result + buttonText;
        }
        result = '0';
        break;
      case '=':
        if (expression.isEmpty) break;
        expression += result;
        try {
          final exp = ShuntingYardParser().parse(expression.replaceAll('x', '*'));
          final evalResult = RealEvaluator().evaluate(exp);
          if (evalResult is double && (evalResult.isInfinite || evalResult.isNaN)) {
            result = 'Error';
          } else if (evalResult == evalResult.toInt()) {
            result = evalResult.toInt().toString();
          } else {
            result = evalResult.toString();
          }
          history = ['$expression = $result', ...history];
        } catch (e) {
          result = 'Error';
        }
        expression = '';
        break;
      case '.':
        if (!result.contains('.')) {
          result += '.';
        }
        break;
      case '+/-':
        if (result != '0') {
          if (result.startsWith('-')) {
            result = result.substring(1);
          } else {
            result = '-$result';
          }
        }
        break;
      case '%':
        try {
          double value = double.parse(result);
          result = (value / 100).toString();
        } catch (e) {
          // ignore
        }
        break;
      default:
        if (result == '0' || result == 'Error') {
          result = buttonText;
        } else {
          result += buttonText;
        }
    }
    state = state.copyWith(expression: expression, result: result, history: history);
  }
}
