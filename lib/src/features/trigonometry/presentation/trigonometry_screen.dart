import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/trigonometry/application/trigonometry_provider.dart';
import 'package:myapp/src/features/trigonometry/presentation/widgets/triangle_painter.dart';

class TrigonometryScreen extends ConsumerStatefulWidget {
  const TrigonometryScreen({super.key});

  @override
  ConsumerState<TrigonometryScreen> createState() => _TrigonometryScreenState();
}

class _TrigonometryScreenState extends ConsumerState<TrigonometryScreen> {
  final _oppositeController = TextEditingController();
  final _adjacentController = TextEditingController();
  final _hypotenuseController = TextEditingController();
  final _angleAController = TextEditingController();
  final _angleBController = TextEditingController();

  final _oppositeFocus = FocusNode();
  final _adjacentFocus = FocusNode();
  final _hypotenuseFocus = FocusNode();
  final _angleAFocus = FocusNode();
  final _angleBFocus = FocusNode();

  @override
  void dispose() {
    _oppositeController.dispose();
    _adjacentController.dispose();
    _hypotenuseController.dispose();
    _angleAController.dispose();
    _angleBController.dispose();
    _oppositeFocus.dispose();
    _adjacentFocus.dispose();
    _hypotenuseFocus.dispose();
    _angleAFocus.dispose();
    _angleBFocus.dispose();
    super.dispose();
  }

  void _updateController(TextEditingController controller, double value, FocusNode focusNode) {
    if (focusNode.hasFocus) return;
    final formattedValue = value.toStringAsFixed(2);
    if (value == 0) {
      controller.clear();
    } else if (controller.text != formattedValue) {
      controller.text = formattedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trigonometryState = ref.watch(trigonometryProvider);

    ref.listen<TrigonometryState>(trigonometryProvider, (previous, next) {
      if (next.opposite == 0 && next.adjacent == 0 && next.hypotenuse == 0 && next.angleA == 0 && next.angleB == 0) {
        _oppositeController.clear();
        _adjacentController.clear();
        _hypotenuseController.clear();
        _angleAController.clear();
        _angleBController.clear();
        return;
      }
      _updateController(_oppositeController, next.opposite, _oppositeFocus);
      _updateController(_adjacentController, next.adjacent, _adjacentFocus);
      _updateController(_hypotenuseController, next.hypotenuse, _hypotenuseFocus);
      _updateController(_angleAController, next.angleA, _angleAFocus);
      _updateController(_angleBController, next.angleB, _angleBFocus);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('SOH CAH TOA Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
            tooltip: 'Open Settings',
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () => context.go('/calculator'),
            tooltip: 'Open Calculator',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: CustomPaint(
                  painter: TrianglePainter(
                    color: theme.colorScheme.primary,
                    state: trigonometryState,
                  ),
                  size: const Size(double.infinity, 300),
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField('Opposite', _oppositeController, _oppositeFocus, (value) => ref.read(trigonometryProvider.notifier).updateOpposite(value)),
              const SizedBox(height: 10),
              _buildInputField('Adjacent', _adjacentController, _adjacentFocus, (value) => ref.read(trigonometryProvider.notifier).updateAdjacent(value)),
              const SizedBox(height: 10),
              _buildInputField('Hypotenuse', _hypotenuseController, _hypotenuseFocus, (value) => ref.read(trigonometryProvider.notifier).updateHypotenuse(value)),
              const SizedBox(height: 10),
              _buildInputField('Angle α', _angleAController, _angleAFocus, (value) => ref.read(trigonometryProvider.notifier).updateAngleA(value)),
              const SizedBox(height: 10),
              _buildInputField('Angle β', _angleBController, _angleBFocus, (value) => ref.read(trigonometryProvider.notifier).updateAngleB(value)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(trigonometryProvider.notifier).reset();
                  FocusScope.of(context).unfocus();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, FocusNode focusNode, void Function(double) onChanged) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final doubleValue = double.tryParse(value);
        onChanged(doubleValue ?? 0);
      },
    );
  }
}
