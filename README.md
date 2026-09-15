# Product Catalog App

A Flutter product catolog app built against the free [DummyJSON] API

## Architecture used

This project uses a **three-layer architecture pattern** that contains presentation (/view), business logic (/domain) and data layer (/data) as well as an external DummyJSON REST API

## Features
- Product list including thumbnails, title and price
- Prouct detail screen containing image, price, rating
- Debounced search product function on the product list screen
- Loading, success, error (with retry), and empty states
- Pull-to-refresh on the product list screen
- Fallback mechanism for broken-image icons

## Tech Stack
- Flutter / Dart
- 'http' package for networking
- Flutter's built-in 'ChangeNotifier' + 'LitenableBuilder' (no third-party state management package)

## Project Structure
lib/
├── data/
│ ├── models/product.dart
│ ├── sources/product_api_source.dart
│ ├── repositories/product_repository.dart
│ ├── repositories/product_repository_impl.dart
│ └── exceptions/api_exception.dart
├── domain/
│ ├── view_state.dart
│ ├── product_list_controller.dart
│ └── product_detail_controller.dart
├── view/
│ ├── screens/product_list_screen.dart
│ ├── screens/product_detail_screen.dart
│ ├── widgets/product_card.dart
│ ├── widgets/search_bar_widget.dart
│ ├── widgets/loading_view.dart
│ ├── widgets/error_view.dart
│ ├── widgets/empty_view.dart
│ ├── theme/app_theme.dart
│ └── theme/app_colors.dart
└── main.dart

## API
- List: `GET https://dummyjson.com/products?limit=20&skip=0` 
- Detail: `GET https://dummyjson.com/products/{id}`
-  Search: `GET https://dummyjson.com/products/search?q=phone`


No API key required

## How to Run
```bash
flutter pub get
flutter run
```

## Testing
```bash
flutter test
```