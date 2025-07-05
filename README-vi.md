## **🔗 ULoC — UI-Logic-Controller / Router for Flutter**

**ULoC** là một công cụ thân thiện với lập trình viên bao gồm routing, logic injection và tạo sẵn màn hình vào một luồng công việc liền mạch cho Flutter.  
Nó được thiết kế để hoạt động hoàn hảo với **Provider**, và tuân theo các mẫu kiến trúc có thể mở rộng như **MVC** hoặc **MVVM**.

> Đừng viết tay các route nữa. Hãy để ULoC xử lý, bạn chỉ cần tập trung vào logic và UI.

---

## 🧭 Tổng Quan

- 🔧 Dựa trên `provider` để dễ dàng quản lý state và logic
- 🔁 Tự động gen `Routes` và map `ULoC` từ `@ULoCDeclaration`
- 🧱 Tạo nhanh màn hình mới gồm controller + view
- 🧬 Lifecycle hook (`onInit`, `onReady`, `onDispose`)
- 🚀 Hỗ trợ named routes động với tham số — lý tưởng cho deep linking
- ✅ Phù hợp với dự án lớn và kiến trúc mở rộng (MVC/MVVM)

---

## 📦 Cài Đặt

Trong project Flutter của bạn:

```yaml
dependencies:
  uloc: ^1.0.0
```

Sau đó:

```bash
dart pub get
```

---

## ⚙️ Các Lệnh CLI

### 🔁 Tạo Routes Tự Động

Tạo hằng số route và bản đồ ULoC:

```bash
dart run uloc gen
```

### 📁 Tạo Route từ → đến

```bash
dart run uloc gen <source_file.dart> <destination_file.dart>
```

### 🧱 Tạo Màn Hình Mới

Tạo `YourScreen` và `YourScreenController`:

```bash
dart run uloc new <WidgetName> <Directory>
```

**Ví dụ:**

```bash
dart run uloc new home_page lib/screens/
```

Sinh ra:

```
lib/screens/home/
├── views/pages/home_page.dart
└── controllers/home_controller.dart
```

---

## ✨ Ví dụ Khai Báo Route

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

## 📄 Kết Quả Sinh Ra

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

---

## 📄 Cách Dùng

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

Mỗi controller có thể định nghĩa các phương thức vòng đời:

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
  removeResource();
}
```

---

## 🧠 Kiến Trúc Hỗ Trợ

ULoC phù hợp với các kiến trúc hiện đại:

- **MVC** — Controller xử lý logic, View là UI
- **MVVM** — Controller = ViewModel, View quan sát thay đổi
- Phân tách rõ ràng giữa logic và UI

---

## 🔗 Deep Linking

Named routes hỗ trợ `:params` như `/user/:id`. Điều hướng với:

```dart
context.pushNamed(Routes.Detail(id: '42'))
```

Hoạt động tốt với Firebase Dynamic Links, URI parsers, v.v.

---

## ❤️ Đóng Góp

Chào đón mọi đóng góp:

- Gửi báo lỗi hoặc ý tưởng
- Tạo pull request
- Giúp cải thiện hệ sinh thái

---

## 📄 Giấy Phép

MIT License © NGUYEN HAI DANG
