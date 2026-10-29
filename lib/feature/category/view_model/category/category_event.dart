import 'package:equatable/equatable.dart';
import 'package:out_split_in/feature/category/model/category_item_model.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends CategoryEvent {
  const LoadCategoriesEvent();
}

class FilterCategoryTypeEvent extends CategoryEvent {
  final TransactionType type;

  const FilterCategoryTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class AddCustomCategoryEvent extends CategoryEvent {
  final CategoryItemModel category;

  const AddCustomCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class DeleteCustomCategoryEvent extends CategoryEvent {
  final String categoryId;

  const DeleteCustomCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
