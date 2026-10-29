import 'package:equatable/equatable.dart';
import 'package:out_split_in/feature/category/model/category_item_model.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

enum CategoryStatus { initial, loading, loaded, error }

class CategoryState extends Equatable {
  final List<CategoryItemModel> allCategories;
  final TransactionType selectedType;
  final CategoryStatus status;
  final String? errorMessage;

  const CategoryState({
    this.allCategories = const [],
    this.selectedType = TransactionType.expense,
    this.status = CategoryStatus.initial,
    this.errorMessage,
  });

  List<CategoryItemModel> get filteredCategories {
    return allCategories.where((cat) => cat.type == selectedType).toList();
  }

  CategoryState copyWith({
    List<CategoryItemModel>? allCategories,
    TransactionType? selectedType,
    CategoryStatus? status,
    String? errorMessage,
  }) {
    return CategoryState(
      allCategories: allCategories ?? this.allCategories,
      selectedType: selectedType ?? this.selectedType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allCategories,
        selectedType,
        status,
        errorMessage,
      ];
}
