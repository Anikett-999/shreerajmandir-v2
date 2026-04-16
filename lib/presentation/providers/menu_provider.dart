import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/category.dart';
import '../../domain/models/item.dart';
import '../../services/menu_service.dart';
import 'active_branch_provider.dart';

// Provider for MenuService
final menuServiceProvider = Provider<MenuService>((ref) {
  final branchId = ref.watch(activeBranchIdProvider);
  if (branchId == null) throw Exception('No active branch selected');
  return MenuService(branchId: branchId);
});

// Stream of All Categories (sorted by order)
final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final service = ref.watch(menuServiceProvider);
  return service.watchCategories();
});

// State for the currently selected category ID in the management UI
final selectedCategoryIdProvider = StateProvider<String?>((ref) {
  // Watch branchId so this provider resets to null when branch changes
  ref.watch(activeBranchIdProvider);
  return null;
});

// Stream of Items for the selected category
final itemsByCategoryProvider = StreamProvider<List<Item>>((ref) {
  final service = ref.watch(menuServiceProvider);
  final selectedId = ref.watch(selectedCategoryIdProvider);
  
  if (selectedId == null) return Stream.value([]);
  
  return service.watchItemsByCategory(selectedId);
});

// Stream of All Available Items (for waiters/ordering)
final availableItemsStreamProvider = StreamProvider<List<Item>>((ref) {
  final service = ref.watch(menuServiceProvider);
  return service.watchAvailableItems();
});

// Controller for Menu Actions (CRUD)
final menuControllerProvider = Provider((ref) => MenuController(ref));

class MenuController {
  final Ref _ref;
  MenuController(this._ref);

  MenuService get _service => _ref.read(menuServiceProvider);

  // Category Actions
  Future<void> saveCategory(Category category) async {
    await _service.upsertCategory(category);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _service.deleteCategory(categoryId);
  }

  Future<void> reorderCategories(List<Category> categories) async {
    await _service.updateCategoryOrder(categories);
  }

  // Item Actions
  Future<void> saveItem(Item item) async {
    await _service.upsertItem(item);
  }

  Future<void> deleteItem(String itemId) async {
    await _service.deleteItem(itemId);
  }

  Future<void> toggleItemAvailability(String itemId, bool isAvailable) async {
    await _service.updateItemAvailability(itemId, isAvailable);
  }
}
