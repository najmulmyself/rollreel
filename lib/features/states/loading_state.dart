import 'package:flutter/cupertino.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: RRSpace.sp20, vertical: RRSpace.sp8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: RRColors.bgElevated,
                  borderRadius: BorderRadius.circular(RRSpace.radiusMd),
                ),
              ),
              const SizedBox(width: RRSpace.sp12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 160, color: RRColors.bgElevated),
                    const SizedBox(height: RRSpace.sp8),
                    Container(height: 10, width: 80, color: RRColors.bgElevated),
                  ],
                ),
              ),
              const CupertinoActivityIndicator(),
            ],
          ),
        );
      },
    );
  }
}
