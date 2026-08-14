import 'package:flutter/material.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';

class ServiceCategories extends StatefulWidget {
  const ServiceCategories({super.key});

  @override
  State<ServiceCategories> createState() => _ServiceCategoriesState();
}

class _ServiceCategoriesState extends State<ServiceCategories> {
  final Map<String, bool> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    // Initialize all sections as collapsed
    for (var section in _serviceSections) {
      _expandedSections[section['title']] = false;
    }
  }

  static const List<Map<String, dynamic>> _serviceSections = [
    {
      'title': 'Emergency & Outdoor Services',
      'icon': Icons.home_work_outlined,
      'color': AppColors.primary,
      'services': [
        {'name': 'Grass Cutting', 'icon': Icons.grass},
        {'name': 'Leaf Clearing', 'icon': Icons.autofps_select},
        {'name': 'Tree Cutting', 'icon': Icons.forest},
        {'name': 'Garden Maintenance', 'icon': Icons.yard},
        {'name': 'Hedge Trimming', 'icon': Icons.content_cut},
        {'name': 'Fence Repair', 'icon': Icons.fence},
        {'name': 'Waste Removal', 'icon': Icons.delete_outline},
      ],
    },
    {
      'title': 'Technology & Office Services',
      'icon': Icons.computer_outlined,
      'color': AppColors.secondary,
      'services': [
        {'name': 'Data Entry', 'icon': Icons.input},
        {'name': 'Document Formatting', 'icon': Icons.format_align_left},
        {'name': 'Printing & Scanning', 'icon': Icons.print},
        {'name': 'Computer Repair', 'icon': Icons.build},
        {'name': 'Laptop Troubleshooting', 'icon': Icons.laptop},
        {'name': 'Software Installation', 'icon': Icons.download},
        {'name': 'Computer Tutoring', 'icon': Icons.school},
        {'name': 'Internet Setup', 'icon': Icons.wifi},
      ],
    },
    {
      'title': 'Cooking & Food Services',
      'icon': Icons.restaurant_outlined,
      'color': AppColors.accent,
      'services': [
        {'name': 'Personal Chef', 'icon': Icons.person},
        {'name': 'Event Cooking', 'icon': Icons.event},
        {'name': 'Cake Baking', 'icon': Icons.cake},
        {'name': 'Cooking Tutor', 'icon': Icons.school},
        {'name': 'Meal Preparation', 'icon': Icons.food_bank},
        {'name': 'Traditional Food', 'icon': Icons.local_dining},
      ],
    },
    {
      'title': 'Fashion & Tailoring Services',
      'icon': Icons.checkroom_outlined,
      'color': AppColors.success,
      'services': [
        {'name': 'Tailor', 'icon': Icons.cut},
        {'name': 'Dress Making', 'icon': Icons.woman},
        {'name': 'Suit Tailoring', 'icon': Icons.man},
        {'name': 'Fashion Designer', 'icon': Icons.design_services},
        {'name': 'Sewing Services', 'icon': Icons.home_repair_service},
        {'name': 'Clothing Repair', 'icon': Icons.build},
        {'name': 'Fashion Tutor', 'icon': Icons.school},
      ],
    },
    {
      'title': 'Cleaning Services',
      'icon': Icons.cleaning_services_outlined,
      'color': AppColors.warning,
      'services': [
        {'name': 'House Cleaning', 'icon': Icons.home},
        {'name': 'Yard Cleaning', 'icon': Icons.yard},
        {'name': 'Deep Cleaning', 'icon': Icons.cleaning_services},
        {'name': 'Office Cleaning', 'icon': Icons.business},
        {'name': 'Post-Event Cleaning', 'icon': Icons.event_available},
      ],
    },
    {
      'title': 'Transport & Assistance',
      'icon': Icons.local_shipping_outlined,
      'color': AppColors.error,
      'services': [
        {'name': 'Tyre Repair', 'icon': Icons.tire_repair},
        {'name': 'Battery Jump', 'icon': Icons.battery_std},
        {'name': 'Tow Assistance', 'icon': Icons.car_crash},
        {'name': 'Delivery Services', 'icon': Icons.delivery_dining},
        {'name': 'Moving Assistance', 'icon': Icons.move_to_inbox},
      ],
    },
    {
      'title': 'Home Repair & Maintenance',
      'icon': Icons.handyman_outlined,
      'color': AppColors.premium,
      'services': [
        {'name': 'Plumbing', 'icon': Icons.plumbing},
        {'name': 'Electrical', 'icon': Icons.electrical_services},
        {'name': 'Door Repair', 'icon': Icons.door_front_door},
        {'name': 'Window Repair', 'icon': Icons.window},
        {'name': 'Furniture Repair', 'icon': Icons.weekend},
      ],
    },
    {
      'title': 'Education & Tutoring',
      'icon': Icons.school_outlined,
      'color': AppColors.info,
      'services': [
        {'name': 'Computer Tutoring', 'icon': Icons.computer},
        {'name': 'Academic Tutoring', 'icon': Icons.menu_book},
        {'name': 'Math Tutoring', 'icon': Icons.calculate},
        {'name': 'Language Tutoring', 'icon': Icons.translate},
        {'name': 'Skill Training', 'icon': Icons.psychology},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _serviceSections.length,
      itemBuilder: (context, index) {
        final section = _serviceSections[index];
        final isExpanded = _expandedSections[section['title']] ?? false;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  section['icon'] as IconData,
                  color: section['color'] as Color,
                ),
                title: Text(
                  section['title'] as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _expandedSections[section['title']] = !isExpanded;
                  });
                },
              ),
              if (isExpanded)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: (section['services'] as List).length,
                    itemBuilder: (context, serviceIndex) {
                      final service =
                          (section['services'] as List)[serviceIndex];
                      return _buildServiceItem(context, service);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(BuildContext context, Map<String, dynamic> service) {
    return InkWell(
      onTap: () {
        // Navigate to service request form
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request: ${service['name']}')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              service['icon'] as IconData,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              service['name'] as String,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
