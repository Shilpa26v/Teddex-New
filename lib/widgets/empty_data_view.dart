import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class EmptyDataView extends StatelessWidget {
  final Widget placeholder;
  final String? content;

  const EmptyDataView({Key? key, required this.placeholder, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(width: AdaptiveBreakpoints.small),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: placeholder),
          if (content?.isNotEmpty ?? false) ...[
            const Gap(16),
            Text(content!, style: Theme.of(context).textTheme.bodyMedium),
          ]
        ],
      ),
    );
  }
}
