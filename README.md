## ** ULoC — UI-Logic-Controller / Router for Flutter**

**ULoC** is a developer-friendly tool that combines routing, logic injection, and screen scaffolding into one seamless workflow for Flutter.  
It's designed to work perfectly with **Provider**, and follows scalable patterns like **MVC** or **MVVM**.

> Stop wiring up routes manually. Let ULoC handle it, while you focus on logic and design.

---

## Overview

- 🔧 Based on `provider` for easy state and logic injection
- 🔁 Auto-generates `Routes` and `ULoC` map from a `@ULoCDeclaration`
- 🧱 Scaffolds new screens with controller + view files
- 🧬 Lifecycle hooks (`onInit`, `onReady`, `onDispose`)
- 🚀 Supports dynamic named routes with parameters — great for deep linking
- ✅ Perfect for large projects and scalable architecture (MVC/MVVM)

---

## Functionalities

- Route generate with type safe parameter
- Widget generate
- Separate view and controller
- Convenient lifecycle hook
- Access to context and setstate from any where
- find ancestor provider from previous pages
- Support paramaters and URL query - Great for deeplink
- Easy navigation with custom navigational fucntions in providers
- Named and Widget navigation

---

## Installation

In your Flutter project:

```yaml
dependencies:
  uloc: ^latest
```

Then:

```bash
dart pub get
```

---

## CLI Commands

```sh
# To install globally:
dart pub global activate uloc

# To install to package:
dart pub add uloc

# Usage globally:
uloc <command> [arguments]

# Usage package:
dart run uloc <command> [arguments]

# Print usage information.
uloc help
uloc -h
uloc --help

# Generate routing files.
# Generate routing files for the current project from ULoCDeclaration
# By default, the route declaration dir is lib/routes/routes.dart.
# the target file dir is lib/routes/routes.uloc.g.dart
uloc gen-route
uloc gr
uloc gen-route --dir lib/routes/routes.dart --target lib/routes/routes.uloc.g.dart
uloc gr -d lib/routes/routes.dart -t lib/routes/routes.uloc.g.dart

# Generate new widget page.
# By default, the route declaration dir is lib/app/screens/.
# the structure as below:
# lib/screens/home/
# ├── views/pages/home_page.dart
# └── controllers/home_controller.dart
uloc gen-page home
uloc gp book_detail --parameters id,title
uloc gp book_detail --parameters id --parameters title --gen-route --route-declaration-dir lib/routes/routes.dart --route-target-dir lib/routes/routes.uloc.g.dart
uloc gp home -g -r lib/routes/routes.dart -t lib/routes/routes.uloc.g.dart

# Generate new widget page with type safe parameter
# Please manually import class path after generate
uloc gp detail_page --add-page-arg data-BookDetail -g

```

## Route Declaration Example

```dart
@ULoCDeclaration()
class MyRoutes extends ULoCRouteDeclaration {
  @override
  Map<String, ULoCRoute<ULoCProvider>> get route => {
    'WILDCARD': ULoCRoute(
      route: '*',
      provider: (context, _) => NotFoundController(context),
      child: NotFoundPage,
    ),
    'HOME': ULoCRoute(
      route: '/',
      provider: (context, _) => HomeController(context),
      child: HomePage,
    ),
    'DETAIL': ULoCRouteDefine(
      route: '/detail/:id',
      provider: (context, route) => DetailController(
        context,
        id: route?.param('id'),
        data: route?.arguments<BookDetail>('data'),
      ),
      child: DetailPage,
    ),
  };
}
```

---

## Generated Output

```dart
class Routes {
  Routes._();

  static ULoCRoute WILDCARD = ULoCRoute('*');
  static ULoCRoute HOME = ULoCRoute('/');
  static ULoCRoute DETAIL({String? id, BookDetail? data}) =>
      ULoCRoute('/detail/:id', routeParams: [id], arguments: {'data': data});

  static ULoCRoute fromString(String? url) => ULoCRoute.fromString(url);

  /// use this to pass to [MaterialApp] Route setting
  static final ULoCRouteConfiguration ulocRouteConfiguration = ULoCRouteConfiguration([
    RouteProperties<NotFoundController>(
      routeName: Routes.WILDCARD,
      provider: (context, _) => NotFoundController(context),
      child: NotFoundPage(),
    ),
    RouteProperties<HomeController>(
      routeName: Routes.HOME,
      provider: (context, _) => HomeController(context),
      child: HomePage(),
    ),
    RouteProperties<DetailController>(
      routeName: Routes.DETAIL(),
      provider: (context, route) => DetailController(
        context,
        id: route?.param('id'),
        data: route?.arguments<BookDetail>('data'),
      ),
      child: DetailPage(),
    ),
  ]);
}

```

--

## Controller

```dart
class DetailController extends ULoCProvider {
  final String? id;
  final BookDetail? data;
  DetailController(super.context, {this.id, this.data});
  String name = "Detail";
  String content = "Detail has not yet implemented";

  int count = 0;

  @override
  void init() {
    super.init();

    // get query from route
    String utmSource = query('utm_source');
    Map<String, dynamic> allQuery = queryParametersAll;

    // get Flutter route arguments
    final dynamic args =  arguments;

    // get ULoC route arguments
    final Map<String, dynamic>? args =  ulocArguments;
  }

  @override
  void ready() {
    super.ready();
  }

  @override
  void dispose() {
    super.dispose();
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

## View

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

## Route Usage

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
      initialRoute: Routes.HOME.name,
      onGenerateRoute: Routes.ulocRouteConfiguration.routeBuilder,
    );
  }
}

```

---

## Lifecycle Hooks

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

## Find ancestor provider from previous pages

Each controller can optionally define lifecycle methods:
You can setstate() in controller
Each time setstate() is called, Widgets what are watching will be rerendered

```dart
class MyController extends ULoCProvider{
  // find and use functions
  HomeController? homeController = findAncestorProviderOfType<HomeController>();

  // find and watch data
  String? get watchHomeData => findAncestorProviderOfType<HomeController>(listen: true)?.data;

  // find provider with exact location match
  HomeController? homeController = findAncestorProviderOfType<HomeController>(
    location: "/books/detail/the-invisible-man",
  );

  HomeController? homeController = findAncestorProviderOfType<HomeController>(
    location: Routes.DETAIL(id: "1"),
  );
}
```

---

## Architecture Friendly

ULoC fits into modern app structure:

- **MVC** — Controller handles logic, View is UI
- **MVVM** — Controller = ViewModel, View observes data changes
- Clean separation between logic and UI

---

## Navigation, Deep Linking

Named routes support `:params` like `/user/:id`. Navigate with:

```dart

class Home extends ULoCProvider {
  DetailController(super.context);

  void goToDetailHandle(){
    // named navigation
    getTo(Routes.Detail(id: '42'))
  }

  void goToDetailWithQueryHandle(){
    // named navigation with query
    getTo(Routes.Home.withQuery({ 'utm_source': 'facebook'}))
  }

  void goToCustomPage(){
    // widget navigation with query
    addRoute(
      WidgetPage(),
      provider: (context) => WidgetController(context),
      name: 'custom_route'.withQuery({ 'utm_source': 'facebook'}),
    );
  }
}
```

Works with Firebase Dynamic Links, URI parsers, etc.

```dart

  class DynamicLinkHandler{
    precessLink(String? url){
      final route = Routes.fromString(url)

      if(isAppRoute){
        getTo(route)

        // OR

        return await Navigator.of(
            context,
          ).pushNamed<T>(url);

      } else {
        // other process
      }
    }
  }

```

---

## ❤️ Contributing

Feel free to:

- Submit bug reports or ideas
- Open pull requests
- Improve the ecosystem

---

## 📄 License

MIT License © NGUYEN HAI DANG
