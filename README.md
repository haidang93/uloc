## **🔗 ULoC — UI-Logic-Controller / Router for Flutter**

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

```
///////////////////////////////////////////////////////
//                                                   //
//     //     //  //                     ///////     //
//     //     //  //         //////    ///    ///    //
//     //     //  //        //    //  ///            //
//     //     //  //        //    //  ///   ///      //
//      ///////   ////////   //////    //////        //
//                                                   //
//                     ULoC                          //
///////////////////////////////////////////////////////

Usage: dart run uloc <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:

gen-route, gr: Generate routing files for the current project from ULoCDeclaration - default path: lib/routes/routes.dart.
-d, --dir       Custom routes.dart dir. Default: lib/routes/routes.dart
-t, --target    Custom routes.dart dir. Default: lib/routes/routes.uloc.g.dart

gen-page, gp: Generate new page widget with [name] - default path: lib/app/screens/.
-d, --dir           Custom dir for new page files. Default: lib/app/screens/
-p, --parameters    List of page parameters separated by commas. Ex: id,name,email
```

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
dart run uloc gen-page <widget_name> --dir --parameters
```

**Example:**

```bash
dart run uloc new home_page --dir lib/screens/ --parameters id,type
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
      child: HomePage,
    ),
    'DETAIL': ULoCRoute(
      route: '/detail/:id/:name',
      provider: (context, params) =>
          DetailController(context, id: params?['id'], type: params?['type']),
      child: DetailPage,
    ),
  };
}
```

---

## 📄 Generated Output

```dart
class Routes {
  Routes._();

  static const RouteName HOME = '/';
  static RouteName DETAIL({String? id, String? name}) => id == null && name == null ? '/detail/:id/:name' : '/detail/$id/$name';
}

/// use this to pass to [MaterialApp] Route setting
final ULoC uloc = ULoC([
  RouteProperties<HomeController>(
    routeName: Routes.HOME,
    provider: (context, _) => HomeController(context),
    child: HomePage(),
  ),
  RouteProperties<DetailController>(
    routeName: Routes.DETAIL(),
    provider: (context, params) => DetailController(context, id: params?['id'], type: params?['type']),
    child: DetailPage(),
  ),
]);

```

--

## 📄 Controller

```dart
import 'package:uloc/uloc.dart';

class MyController extends ULoCProvider {
  final String? id;
  final String? type;
  MyController(super.context, {this.id, this.type});
  String name = "Detail";
  String content = "Detail has not yet implemented";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onDispose() {
    super.onDispose();
  }

}

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
