import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const categories = [
    {
      'name': 'Emergency Services',
      'subtitle': 'Fast response for urgent help',
      'icon': Icons.warning_amber_rounded,
      'color': AppColors.error,
      'route': '/services/emergency',
    },
    {
      'name': 'Outdoor & Garden',
      'subtitle': 'Lawn care, trimming, and cleanup',
      'icon': Icons.yard,
      'color': AppColors.success,
      'route': '/services/outdoor',
    },
    {
      'name': 'Technology & Data',
      'subtitle': 'Repairs, setup, and tutoring',
      'icon': Icons.computer,
      'color': AppColors.info,
      'route': '/services/technology',
    },
    {
      'name': 'Cooking & Food',
      'subtitle': 'Meal prep, catering, and baking',
      'icon': Icons.restaurant,
      'color': AppColors.accent,
      'route': '/services/cooking',
    },
    {
      'name': 'Home Services',
      'subtitle': 'Plumbing, electrical and repair',
      'icon': Icons.home_repair_service,
      'color': AppColors.primary,
      'route': '/services/home',
    },
    {
      'name': 'Vehicle Services',
      'subtitle': 'Maintenance and roadside help',
      'icon': Icons.directions_car,
      'color': AppColors.warning,
      'route': '/services/vehicle',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              context.push(category['route'] as String);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color:
                          (category['color'] as Color).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: category['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    category['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'Request now',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: category['color'] as Color,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: category['color'] as Color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
