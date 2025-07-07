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
// To install globally:
dart pub global activate uloc

// To install to package:
dart pub add uloc

// Print usage information.
uloc help
uloc -h
uloc --help

// Generate routing files.
// Generate routing files for the current project from ULoCDeclaration
// By default, the route declaration dir is lib/routes/routes.dart.
// the target file dir is lib/routes/routes.uloc.g.dart
uloc gen-route
uloc gr
uloc gen-route --dir lib/routes/routes.dart --target lib/routes/routes.uloc.g.dart
uloc gr -d lib/routes/routes.dart -t lib/routes/routes.uloc.g.dart

// Generate new widget page.
// By default, the route declaration dir is lib/app/screens/.
// the structure as below:
// lib/screens/home/
// ├── views/pages/home_page.dart
// └── controllers/home_controller.dart
uloc gen-page home
uloc gp book_detail --parameters id,title
uloc gp book_detail --parameters id --parameters title --gen-route --route-declaration-dir lib/routes/routes.dart --route-target-dir lib/routes/routes.uloc.g.dart
uloc gp home -g -r lib/routes/routes.dart -t lib/routes/routes.uloc.g.dart

```

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

  /// use this to pass to [MaterialApp] Route setting
  static final ULoCRouteConfiguration ulocRouteConfiguration = ULoCRouteConfiguration([
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
}

```

--

## 📄 Controller

```dart
class DetailController extends ULoCProvider {
  final String? id;
  final String? type;
  DetailController(super.context, {this.id, this.type});
  String name = "Detail";
  String content = "Detail has not yet implemented";

  int count = 0;

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

  void increment() {
    count++;
    setstate();
  }

  void decrement() {
    setstate(() {
      count--;
    });
  }
}

```

--

## 📄 View

```dart
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // watch will trigger rebuild widget on watch value changed
  DetailController get watch => context.watch<DetailController>();

  // controller gives access to controller properties but won't trigger rebuild on properties' value change
  DetailController get controller => context.read<DetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(watch.name)),
      body: Center(
        child: Text(watch.count.toString(), style: TextStyle(fontSize: 40)),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          FloatingActionButton.small(
            heroTag: 'increment',
            onPressed: controller.increment,
            child: Icon(Icons.add),
          ),
          FloatingActionButton.small(
            heroTag: 'decrement',
            onPressed: controller.decrement,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
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
      routes: Routes.ulocRouteConfiguration.routes,
      onGenerateRoute: Routes.ulocRouteConfiguration.routeBuilder,
    );
  }
}

```

---

## 🔄 Lifecycle Hooks

Each controller can optionally define lifecycle methods:
You can setstate() in controller
Each time setstate() is called, Widgets what are watching will be rerendered

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
context.getTo(Routes.Detail(id: '42'))
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
