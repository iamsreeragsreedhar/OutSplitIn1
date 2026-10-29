import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/feature/category/services/category_service.dart';
import 'package:out_split_in/feature/category/view_model/category/category_event.dart';
import 'package:out_split_in/feature/category/view_model/category/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService categoryService;

  CategoryBloc({required this.categoryService}) : super(const CategoryState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<FilterCategoryTypeEvent>(_onFilterCategoryType);
    on<AddCustomCategoryEvent>(_onAddCustomCategory);
    on<DeleteCustomCategoryEvent>(_onDeleteCustomCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      final categories = await categoryService.getAllCategories();
      emit(
        state.copyWith(
          allCategories: categories,
          status: CategoryStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onFilterCategoryType(
    FilterCategoryTypeEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(selectedType: event.type));
  }

  Future<void> _onAddCustomCategory(
    AddCustomCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await categoryService.saveCustomCategory(event.category);
      final updated = await categoryService.getAllCategories();
      emit(
        state.copyWith(
          allCategories: updated,
          status: CategoryStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: 'Failed to save category: $e',
        ),
      );
    }
  }

  Future<void> _onDeleteCustomCategory(
    DeleteCustomCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await categoryService.deleteCustomCategory(event.categoryId);
      final updated = await categoryService.getAllCategories();
      emit(
        state.copyWith(
          allCategories: updated,
          status: CategoryStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: 'Failed to delete category: $e',
        ),
      );
    }
  }
}
