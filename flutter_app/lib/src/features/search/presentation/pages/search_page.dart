import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/widgets/custom_text_field.dart';
import 'package:tiroconnect/src/features/workers/domain/entities/worker.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = '';
  late Future<List<Worker>> _workersFuture;

  @override
  void initState() {
    super.initState();
    _workersFuture = getIt<WorkerRepository>().getWorkers();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Worker> _applyFilters(List<Worker> workers) {
    final query = _searchController.text.trim().toLowerCase();
    return workers.where((worker) {
      final matchesQuery = query.isEmpty ||
          worker.name.toLowerCase().contains(query) ||
          worker.location.toLowerCase().contains(query) ||
          worker.skills.any((s) => s.toLowerCase().contains(query));

      final matchesCategory = _selectedCategory.isEmpty ||
          worker.skills
              .any((s) => s.toLowerCase() == _selectedCategory.toLowerCase());

      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/role');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _searchController,
              label: 'Search',
              hint: 'Search by name, location, or skill',
              prefixIcon: const Icon(Icons.search),
            ),
            const SizedBox(height: 16),
            _buildFilters(),
            const SizedBox(height: 24),
            _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return ExpansionTile(
      title: const Text('Filters'),
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
          hint: const Text('Category'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: const [
            DropdownMenuItem(value: 'plumbing', child: Text('Plumbing')),
            DropdownMenuItem(value: 'electrical', child: Text('Electrical')),
            DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
            DropdownMenuItem(value: 'gardening', child: Text('Gardening')),
          ],
          onChanged: (value) => setState(() => _selectedCategory = value ?? ''),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return FutureBuilder<List<Worker>>(
      future: _workersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load workers'));
        }
        final results = _applyFilters(snapshot.data ?? []);
        if (results.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('No workers match your search')),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final worker = results[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(worker.name),
                subtitle: Text(
                  '${worker.skills.isNotEmpty ? worker.skills.join(", ") : "General"} • ${worker.location}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => context.push('/worker/${worker.id}'),
              ),
            );
          },
        );
      },
    );
  }
}
