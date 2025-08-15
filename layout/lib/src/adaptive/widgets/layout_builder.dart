import 'package:flutter/widgets.dart';

/// Defines the breakpoints for the App UI.
abstract class AdaptiveBreakpoints {
  /// Max width for a small layout.
  static const double small = 288;

  /// Max width for a standard layout.
  static const double standard = 576;

  /// Max width for a medium layout.
  static const double medium = 864;

  /// Max width for a large layout.
  static const double large = 1152;
}

/// Represents the layout size passed to [AdaptiveBuilder.child].
enum AdaptiveSize {
  /// Small layout
  small,

  /// Standard layout
  standard,

  /// Medium layout
  medium,

  /// Large layout
  large
}

/// Signature for the individual builders (`small`, `standard`, `medium`, `large`).
typedef AdaptiveWidgetBuilder = Widget Function(BuildContext context, Widget? child);

/// {@template adaptive_layout_builder}
/// A wrapper around [Builder] which exposes builders for
/// various adaptive breakpoints.
/// {@endtemplate}
class AdaptiveBuilder extends StatelessWidget {
  /// {@macro adaptive_layout_builder}
  const AdaptiveBuilder({
    Key? key,
    required this.small,
    required this.standard,
    required this.medium,
    required this.large,
    this.child,
  }) : super(key: key);

  /// [AdaptiveWidgetBuilder] for small layout.
  final AdaptiveWidgetBuilder small;

  /// [AdaptiveWidgetBuilder] for standard layout.
  final AdaptiveWidgetBuilder standard;

  /// [AdaptiveWidgetBuilder] for medium layout.
  final AdaptiveWidgetBuilder medium;

  /// [AdaptiveWidgetBuilder] for large layout.
  final AdaptiveWidgetBuilder large;

  /// Optional child widget builder based on the current layout size
  /// which will be passed to the `small`, `standard`, `medium` and `large` builders
  /// as a way to share/optimize shared layout.
  final Widget Function(AdaptiveSize size)? child;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth <= AdaptiveBreakpoints.small) {
          return small(context, child?.call(AdaptiveSize.small));
        }
        if (screenWidth <= AdaptiveBreakpoints.standard) {
          return standard(context, child?.call(AdaptiveSize.standard));
        }
        if (screenWidth <= AdaptiveBreakpoints.medium) {
          return medium(context, child?.call(AdaptiveSize.medium));
        }
        if (screenWidth <= AdaptiveBreakpoints.large) {
          return large(context, child?.call(AdaptiveSize.large));
        }
        return large(context, child?.call(AdaptiveSize.large));
      },
    );
  }
}
