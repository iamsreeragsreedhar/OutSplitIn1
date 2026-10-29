import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/category/view_model/category/category_bloc.dart';
import 'package:out_split_in/feature/category/view_model/category/category_event.dart';
import 'package:out_split_in/feature/category/view_model/category/category_state.dart';
import 'package:out_split_in/feature/category/widgets/add_category_modal.dart';
import 'package:out_split_in/feature/category/widgets/category_card.dart';
import 'package:out_split_in/feature/category/widgets/category_empty_view.dart';
import 'package:out_split_in/feature/category/widgets/category_type_toggle.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(const LoadCategoriesEvent());
  }

  void _confirmDelete(BuildContext context, String categoryId, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete "$name"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE05A62)),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<CategoryBloc>().add(DeleteCustomCategoryEvent(categoryId));
                AppSnackbar.success(context, 'Category removed');
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add_circle_outline_rounded),
        //     tooltip: 'Add Category',
        //     onPressed: () {
        //       final currentType =
        //           context.read<CategoryBloc>().state.selectedType;
        //       AddCategoryModal.show(context, type: currentType);
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0BA874),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Category', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          final currentType = context.read<CategoryBloc>().state.selectedType;
          AddCategoryModal.show(context, type: currentType);
        },
      ),
      body: SafeArea(
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state.status == CategoryStatus.error && state.errorMessage != null) {
              AppSnackbar.error(context, state.errorMessage!);
            }
          },
          builder: (context, state) {
            if (state.status == CategoryStatus.loading && state.allCategories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final categories = state.filteredCategories;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 80),
                  child: Column(
                    children: [
                      AppFadeSlide(
                        direction: SlideDirection.fromTop,
                        child: CategoryTypeToggle(
                          selectedType: state.selectedType,
                          onTypeChanged: (type) {
                            context.read<CategoryBloc>().add(FilterCategoryTypeEvent(type));
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: categories.isEmpty
                            ? const CategoryEmptyView()
                            : RefreshIndicator(
                                onRefresh: () async {
                                  context.read<CategoryBloc>().add(const LoadCategoriesEvent());
                                },
                                child: ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: categories.length,
                                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final cat = categories[index];
                                    return AppFadeSlide(
                                      delay: Duration(milliseconds: (index.clamp(0, 10)) * 30),
                                      direction: SlideDirection.fromBottom,
                                      child: CategoryCard(
                                        category: cat,
                                        onDelete: cat.isCustom
                                            ? () => _confirmDelete(context, cat.id, cat.name)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
