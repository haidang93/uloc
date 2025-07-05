# 🔗 ULoC — UI-Logic-Controller / Router for Flutter

**ULoC** is a developer-friendly tool that combines routing, logic injection, and screen scaffolding into one seamless workflow for Flutter.  
It's designed to work perfectly with **Provider**, and follows scalable patterns like **MVC** or **MVVM**.

> Stop wiring up routes manually. Let ULoC handle it, while you focus on logic and design.

---

## 🧭 Overview

- 🔧 Based on `provider` for easy state and logic injection
- 🔁 Auto-generates `Routes` and `ULoC` map from a `@ULoCDeclaration`
- 🧱 Scaffolds new screens with controller + view files
- 🧬 Lifecycle hooks (`onInit`, `onReady`, `onDispose`)
- 🚀 Supports dynamic named routes with parameters — great for deep linking
- ✅ Perfect for large projects and scalable architecture (MVC/MVVM)

---

## 📦 Installation

In your Flutter project:

```yaml
dependencies:
  uloc: ^1.0.0
```

Then:

```bash
dart pub get
```

---

## ⚙️ CLI Commands

### 🔁 Generate Routes

Auto-generates route constants and ULoC map:

```bash
dart run uloc gen
```

### 📁 Generate Routes from → to

```bash
dart run uloc gen <source_file.dart> <destination_file.dart>
```

### 🧱 Scaffold a New Screen

Creates `YourScreen` and `YourScreenController`:

```bash
dart run uloc new <WidgetName> <Directory>
```

**Example:**

```bash
dart run uloc new home_page lib/screens/
```

Creates:

```
lib/screens/home/
├── views/pages/home_page.dart
└── controllers/home_controller.dart
```

---

## ✨ Route Declaration Example

```dart
@ULoCDeclaration()
class MyRoutes extends ULoCRouteDeclaration {
  @override
  Map<String, ULoCRoute<ULoCProvider>> get route => {
    'HOME': ULoCRoute(
      route: '/',
      provider: (context, _) => HomeController(context),
      child: Home,
    ),
    'DETAIL': ULoCRoute(
      route: '/detail/:id/:name',
      provider: (context, params) =>
          DetailController(context, params?['id'], params?['name']),
      child: Detail,
    ),
  };
}
```

---

## 📄 Generated Output

```dart
class Routes {
  static const RouteName HOME = '/';
  static RouteName DETAIL({String? id, String? name}) =>
      (id == null || name == null)
          ? '/detail/:id/:name'
          : '/detail/$id/$name';
}

final ULoC uloc = ULoC([
  RouteProperties(
    routeName: Routes.HOME,
    provider: (context, _) => HomeController(context),
    child: Home(),
  ),
  RouteProperties(
    routeName: Routes.DETAIL(),
    provider: (context, params) =>
        DetailController(context, params?['id'], params?['name']),
    child: Detail(),
  ),
]);
```

--

## 📄 Usage

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ULoC Demo',
      initialRoute: Routes.HOME,
      routes: uloc.routes,
      onGenerateRoute: uloc.routeBuilder,
    );
  }
}

```

---

## 🔄 Lifecycle Hooks

Each controller can optionally define lifecycle methods:

```dart
@override
void onInit() {
  fetchData();
}

@override
void onReady() {
  showDialog();
  accessContext();
}

@override
void onDispose() {
  removeResource()
}
```

---

## 🧠 Architecture Friendly

ULoC fits into modern app structure:

- **MVC** — Controller handles logic, View is UI
- **MVVM** — Controller = ViewModel, View observes data changes
- Clean separation between logic and UI

---

## 🔗 Deep Linking

Named routes support `:params` like `/user/:id`. Navigate with:

```dart
context.pushNamed(Routes.Detail(id: '42'))
```

Works with Firebase Dynamic Links, URI parsers, etc.

---

## ❤️ Contributing

Feel free to:

- Submit bug reports or ideas
- Open pull requests
- Improve the ecosystem

---

## 📄 License

MIT License © NGUYEN HAI DANG
