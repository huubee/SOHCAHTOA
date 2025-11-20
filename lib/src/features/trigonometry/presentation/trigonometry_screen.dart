import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trig_sct/src/features/trigonometry/application/trigonometry_provider.dart';
import 'package:trig_sct/src/features/trigonometry/presentation/widgets/triangle_painter.dart';
import 'package:trig_sct/src/localization/app_localizations.dart';

class TrigonometryScreen extends ConsumerStatefulWidget {
  const TrigonometryScreen({super.key});

  @override
  ConsumerState<TrigonometryScreen> createState() => _TrigonometryScreenState();
}

class _TrigonometryScreenState extends ConsumerState<TrigonometryScreen> with SingleTickerProviderStateMixin {
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

  late AnimationController _animationController;
  late Animation<double> _triangleAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _triangleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

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
    _animationController.dispose();
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
    final localizations = AppLocalizations.of(context)!;

    ref.listen<TrigonometryState>(trigonometryProvider, (previous, next) {
      if (next.opposite == 0 && next.adjacent == 0 && next.hypotenuse == 0 && next.angleA == 0 && next.angleB == 0) {
        _oppositeController.clear();
        _adjacentController.clear();
        _hypotenuseController.clear();
        _angleAController.clear();
        _angleBController.clear();
        _hasAnimated = false;
        _animationController.reset();
        return;
      }
      
      // Check if we have angle alpha and at least 2 values for animation
      final hasAngleAlpha = next.angleA > 0 && next.angleA < 90;
      final hasTwoValues = [
        next.opposite > 0,
        next.adjacent > 0,
        next.hypotenuse > 0,
        next.angleA > 0,
        next.angleB > 0,
      ].where((v) => v).length >= 2;
      
      // Check if angle alpha changed (for re-animation)
      final angleChanged = previous != null && 
          previous.angleA != next.angleA &&
          next.angleA > 0;
      
      // Animate triangle if angle alpha is available and we have 2+ values
      if (hasAngleAlpha && hasTwoValues) {
        if (!_hasAnimated) {
          // First time animation
          _hasAnimated = true;
          _animationController.forward();
        } else if (angleChanged) {
          // Angle changed - re-animate smoothly
          _animationController.reset();
          _animationController.forward();
        }
      } else if (!hasAngleAlpha || !hasTwoValues) {
        // Reset animation if conditions are no longer met
        _hasAnimated = false;
        _animationController.reset();
      }
      
      _updateController(_oppositeController, next.opposite, _oppositeFocus);
      _updateController(_adjacentController, next.adjacent, _adjacentFocus);
      _updateController(_hypotenuseController, next.hypotenuse, _hypotenuseFocus);
      _updateController(_angleAController, next.angleA, _angleAFocus);
      _updateController(_angleBController, next.angleB, _angleBFocus);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.trigonometryTitle),
        automaticallyImplyLeading: false, // Don't show back button on home screen
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
            tooltip: localizations.pageSettingsTitle,
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () => context.go('/calculator'),
            tooltip: localizations.calculatorTitle,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final padding = 16.0 * 2; // Left and right padding
          final availableWidth = screenWidth - padding;
          final triangleHeight = math.min(300.0, availableWidth * 0.6);
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: triangleHeight,
                    width: availableWidth,
                    child: AnimatedBuilder(
                      animation: _triangleAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: TrianglePainter(
                            color: theme.colorScheme.primary,
                            state: trigonometryState,
                            animationValue: _triangleAnimation.value,
                            localizations: localizations,
                          ),
                          size: Size(availableWidth, triangleHeight),
                        );
                      },
                    ),
                  ),
              const SizedBox(height: 20),
              _buildInputField(
                localizations.opposite,
                _oppositeController,
                _oppositeFocus,
                (value) => ref.read(trigonometryProvider.notifier).updateOpposite(value),
                ref.read(trigonometryProvider.notifier).isFieldEditable('opposite'),
                localizations,
              ),
              const SizedBox(height: 10),
              _buildInputField(
                localizations.adjacent,
                _adjacentController,
                _adjacentFocus,
                (value) => ref.read(trigonometryProvider.notifier).updateAdjacent(value),
                ref.read(trigonometryProvider.notifier).isFieldEditable('adjacent'),
                localizations,
              ),
              const SizedBox(height: 10),
              _buildInputField(
                localizations.hypotenuse,
                _hypotenuseController,
                _hypotenuseFocus,
                (value) => ref.read(trigonometryProvider.notifier).updateHypotenuse(value),
                ref.read(trigonometryProvider.notifier).isFieldEditable('hypotenuse'),
                localizations,
              ),
              const SizedBox(height: 10),
              _buildInputField(
                localizations.angleAlpha,
                _angleAController,
                _angleAFocus,
                (value) => ref.read(trigonometryProvider.notifier).updateAngleA(value),
                ref.read(trigonometryProvider.notifier).isFieldEditable('angleA'),
                localizations,
              ),
              const SizedBox(height: 10),
              _buildInputField(
                localizations.angleBeta,
                _angleBController,
                _angleBFocus,
                (value) => ref.read(trigonometryProvider.notifier).updateAngleB(value),
                ref.read(trigonometryProvider.notifier).isFieldEditable('angleB'),
                localizations,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(trigonometryProvider.notifier).reset();
                  FocusScope.of(context).unfocus();
                },
                child: Text(localizations.clear),
              ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, FocusNode focusNode, void Function(double) onChanged, bool isEditable, AppLocalizations localizations) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: isEditable,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: !isEditable,
        fillColor: isEditable ? null : Colors.grey[200],
        hintText: isEditable ? null : localizations.calculatedValue,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        color: isEditable ? null : Colors.grey[600],
      ),
      onChanged: isEditable ? (value) {
        // Allow empty string to clear the value
        if (value.isEmpty) {
          onChanged(0);
          return;
        }
        final doubleValue = double.tryParse(value);
        if (doubleValue != null) {
          onChanged(doubleValue);
        }
      } : null,
    );
  }
}
