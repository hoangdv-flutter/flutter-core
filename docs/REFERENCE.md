# flutter_core — Package Reference

Canonical reference cho package `flutter_core`. **File này sống trong submodule** → mọi project dùng `flutter_core` có sẵn doc này, không cần gen lại. Khi thêm/sửa component trong core, cập nhật file này.

Import: `package:flutter_core/core.dart`

> ⚠️ Doc này mô tả **core cung cấp gì** (trung tính). Quyết định *dùng / không dùng* cái nào là của **từng project** — ghi ở `AGENTS.md`/convention của project đó, KHÔNG ghi vào đây.

---

## 1. Base UI Classes

### BaseScreen (StatelessWidget)
Override `onBuild(BuildContext)` instead of `build`. Handles `PopScope`/back-press on both platforms.
```dart
class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});
  @override
  Widget onBuild(BuildContext context) => Scaffold(...);
}
```

### BaseScreenState\<S\> (StatefulWidget state)
Extends `BaseState`, mixes `BaseScreenMixin`. Override `onBuild`. Exposes `onBackPressed` / `onBackPressedIOS`.

### BaseState\<W\>
Safe `setState` — guards `mounted` and swallows errors. Use instead of raw `State<W>`.

### LifecycleStateWatcher\<W\>
Extends `BaseState`, adds `WidgetsBindingObserver`. Override any of: `onResumed / onPaused / onInactive / onDetached`.

### BaseScreenMixin
`canPop` returns `true` only on iOS (used by `PopScope`).

### ScreenTemplate
Convenience scaffold: coloured background + optional extra background layers + `SafeArea`.
```dart
ScreenTemplate(backgroundColor: Colors.white, additionBackground: [...], child: myContent)
```

---

## 2. Presenter (State Management)

### BaseCubit\<T\>
Extends `flutter_bloc` `Cubit`. Key additions:

| Member | Purpose |
|---|---|
| `dataOrNull` | Last emitted state (readable without stream) |
| `runTask(fn)` | Run async work, returns result |
| `runBlockTask(fn)` | Run async work but skip if already busy |
| `emit(state)` | Guards `isClosed` before emitting |

```dart
class CounterCubit extends BaseCubit<int> {
  CounterCubit() : super(0);
  void increment() => runTask(() async { emit(state + 1); return null; });
}
```

### BaseChangeNotifier
`ChangeNotifier` with a `disposed` flag to guard calls after `dispose()`.

---

## 3. Dialog Base Classes (`base_dialog.dart`)

### BaseDialogStateless
`StatelessWidget` for dialogs. Takes `rootContext`. Call `dismiss()` / `dismissDialog()` to close.

### BaseDialogStateful + DialogState\<D\>
`StatefulWidget` + `State` pair for stateful dialogs. `DialogState` has `dismiss()` / `dismissDialog()` with `available` guard (prevents double-dismiss).

### DialogWindow
Concrete transparent-scaffold dialog. Optional `child` widget; state (`DialogWindowsState`) exposes `switchChild(widget)` to swap content at runtime.

### DialogManager
```dart
await DialogManager.showDialogWindow(context: context, dialogContent: MyWidget());
```

### ConfirmDialog
Ready-made confirm dialog with optional title, message, negative/positive buttons.
```dart
ConfirmDialog(
  rootContext: context,
  title: "Confirm",
  message: "Are you sure?",
  positiveButton: MenuButton(title: "Yes", clickListener: () { ... }),
  negativeButton: MenuButton(title: "No"),
)
```
`MenuButton` — holds `title` + `clickListener`.

---

## 4. Data Layer

### Response\<T\>
Wraps success/failure from remote calls.
```dart
Response.success(value)    // .isSuccess == true
Response.failed(exception) // .isSuccess == false
```

### Result\<T\>
Combines `DataState` enum + optional `data` payload.

### DataState (enum)
`idle | loaded | loading | error | open | close`

### ValueWrapper\<V\>
Thin wrapper to distinguish "value is explicitly set" from null.

### ObjectReference\<T\>
Mutable reference holder. `clearReferences()` sets `value = null`.

### Executable → LocalDataSource / RemoteDataSource
Base for data-source classes. Provides:
- `executeTask(fn)` — async, swallows exceptions
- `executeSingleTask(fn)` — same but skips if already busy

### Equatable
Manual equality via `List<dynamic> get properties`.

### SupportedLanguage
Holds `langCode`, `name`, optional `flagLangCode`, derives a `Locale`.

### PremiumHolder (`@singleton`)
Persists premium status to `SharedPreferences`.
```dart
final p = appInject<PremiumHolder>();
p.isPremium        // bool
p.isLifetime = true
p.premiumDay = DateTime.now().add(...).millisecondsSinceEpoch
p.isPremiumStream  // ValueStream<bool>
```

---

## 5. DI (GetIt + Injectable)

### Setup
```dart
await core.setupDI(GetIt.instance); // core singletons
await _getItInstance.init();         // app-level
```

### AppModule (core-provided singletons)
- `SharedPreferences` — `@singleton @preResolve`
- `PackageInfo` — `@singleton @preResolve`

### appInject / appInjectAsync
```dart
final prefs = appInject<SharedPreferences>();
final info  = await appInjectAsync<PackageInfo>();
```

---

## 6. Sizing & Theme

### Sizing

`Sizing.init(context)` (gọi 1 lần ở App root) → cache `screenWidth/Height/pixelRatio/aspectRatio`. Extensions trên `num`:

| Extension | Meaning |
|---|---|
| `n.w` | n% of screen width |
| `n.h` | n% of screen height |
| `n.p` | n% of shortest dimension |
| `n.sp` | Responsive font size |

```dart
Container(width: 80.w, height: 10.h)
Text("Hi", style: TextStyle(fontSize: 2.sp))
```

> ⚠️ **Caveat (mỗi project tự cân nhắc):** giá trị cache **set-once** ở App root → KHÔNG tự re-compute khi xoay màn / resize / split-screen. Nếu cần truly-responsive, dùng `MediaQuery.sizeOf(context)` trong widget thay vì `Sizing`.

### Device (advanced sizing)

`Device.setScreenSize` + `Adaptive.w/h` static wrappers — cùng cơ chế set-once như `Sizing` (cùng caveat resize).

### AppColor / ColorLight / ColorDark
`AppColor` abstract: `colorWhite`, `colorBlack`, `colorGrey`. Extend to add project tokens.
Access via `appColor` global (set to `ColorLight()` by default). Never hardcode hex.

| Token | ColorLight | ColorDark |
|---|---|---|
| `colorBlack` | `#000000` | `#FFFFFF` (swapped) |
| `colorWhite` | `#FFFFFF` | `#000000` (swapped) |
| `colorGrey` | `#676767` | `#D4D4D4` |

`ColorDark extends ColorLight` — only overrides the 3 base tokens.

### setSystemUIColor (ThemeHelper)
```dart
setSystemUIColor(Colors.white, theme: SystemUiOverlayStyle.dark);
```

### AppBarHelper
```dart
AppBarHelper.buildAppbar(toolbarWidget, systemOverlayStyle: ...)
// Returns a transparent AppBar with 8.h height, no leading implied
```

---

## 7. Widgets

### ScalingButton
Press-to-scale animation; `onTap` fires after animation completes.
```dart
ScalingButton(scale: 0.9, onTap: () { ... }, child: Icon(Icons.play_arrow))
```

### GradientButton
```dart
GradientButton(gradient: LinearGradient(...), onPress: () { ... }, child: Text("Go"))
```

### NinePatchPanel
Render **9-patch ĐA ĐOẠN** (multiple stretch segments) từ file `.9.png` — đọc marker 1-px trực tiếp (cạnh trên→stretch ngang, cạnh trái→stretch dọc, cạnh phải/dưới→content box), vẽ lưới N×M: ô cố định giữ tỉ lệ (`×scale`), ô stretch hút phần dư. Hơn hẳn `DecorationImage.centerSlice` (chỉ 3×3 — méo các đốt trang trí giữa cạnh khi khung cao/thấp khác nhau). Marker parse 1 lần/asset rồi cache `static` (share toàn app); `shouldRepaint=false` → steady-state ~0 chi phí.
```dart
NinePatchPanel(
  assetPath: 'assets/app/icon/bg_panel_wood.9.png', // .9.png còn nguyên 1-px marker
  scale: 0.5,        // thu nhỏ vùng cố định (góc/đốt), giữ tỉ lệ. 1.0 = native px
  padding: null,     // cộng thêm vào content box parse từ asset
  child: someWidget,
)
```
> Truyền thẳng `.9.png` (có marker) — panel tự cắt 1-px border khi vẽ, marker không hiện. KHÔNG cần file stripped / metadata json.

### Toolbar + MenuItem
Flexible app-bar row: optional back icon, centred/left title, right menu items.
```dart
Toolbar(
  icon: const Icon(Icons.arrow_back),
  onIconPressed: () => context.popScreen(),
  title: "My Screen",
  menuItems: [MenuItem(icon: Icon(Icons.share), clickListener: () { ... })],
)
```

### HSlider
Custom horizontal slider with animated thumb, optional `progressStream`, touch callbacks.
```dart
HSlider(
  min: 0, max: 100, value: 50,
  progressColor: Colors.blue,
  onProgressChange: (v) { ... },
  onStopTrackingTouch: (v) { ... },
  customThumb: (animProgress) => MyThumb(animProgress),
)
```

### PagerView
`PageView` driven by `PageControllerCubit` (requires `BlocProvider` in ancestor).
```dart
BlocProvider(
  create: (_) => PageControllerCubit(),
  child: PagerView(children: [Screen1(), Screen2()]),
)
```

### BottomNavigationView + PageControllerCubit
Animated bottom nav paired with `PagerView` via `PageControllerCubit`.
```dart
BlocProvider(
  create: (_) => PageControllerCubit(),
  child: Column(children: [
    Expanded(child: PagerView(children: [...])),
    BottomNavigationView(
      menuItems: [BottomMenuItem(icon: "home"), ...],
      onBuildItem: (index, item, t, isSelected) => ...,
    ),
  ]),
)
```

### MyListView / MyListViewState\<D, T\>
Abstract stateful list widget with built-in loading/placeholder/animated-list support.

Subclass `MyListViewState` and override `buildListItem(context)`:
```dart
class MyList extends MyListView<ItemModel> { ... }
class MyListState extends MyListViewState<ItemModel, MyList> {
  @override
  void setupCubitLogic() {
    listenListStream(myCubit.listStream);      // full-list updates
    listenItemUpdateStream(myCubit.itemStream); // single-item updates
  }
  @override
  Widget buildListItem(BuildContext context) => ListView.builder(...);
}
```

Key methods: `replace(list)`, `insert(item)`, `insertAll(list)`, `removeAt(index)`, `remove(item)`, `update(index, item)`.

Key types:
- `ListItemUpdate<D>` — `action: ItemUpdateAction (add | replace | remove | loading)` + `data: List<D>`
- `ItemUpdate<D>` — same for single items + `index`
- `ListState` — `loading | loaded | loadMore`

### ItemViewStateless\<D\> / ItemViewStateful\<D\>
Base classes for list-item widgets. Hold typed `data` + `index`.

---

## 8. Navigation

### RouterCreator
```dart
RouterCreator.createRouter(
  pageBuilder: (ctx, anim, _) => MyScreen(),
  settings: RouteSettings(name: '/home', arguments: args),
)
// Android: PageRouteBuilder with slide transition (200ms)
// iOS: MaterialPageRoute
```

### MyRoute
`MaterialPageRoute` with configurable `transitionDuration`.

### RouteSetting\<T\> (GoRouter)
Wraps a `GoRoute` + optional `extras` typed argument.

### GlobalStateManager
```dart
GlobalStateManager.updateCurrentScreenContext(navigatorKey);
GlobalStateManager.navigationKey; // GlobalKey<NavigatorState>?
```

---

## 9. Extensions

### ObjectExt\<T\>
```dart
value.takeIf(condition: (v) => v > 0)  // T? — null if false
value.also(call: (v) { log(v); })       // side-effect, returns self
value.let(call: (v) => v * 2)           // transform
```

### Global helpers (ext/app.dart)
```dart
await process(() => apiCall())              // → Response<T> (never throws)
runCatching(() => risky(), onError: (e) {}) // → T? (sync)
await runCatchingAsync(() => risky())        // → T? (async)
```

### ContextExt
```dart
context.pushScreen(route, isReplacement: false) // → dynamic
context.pushDialog(widget)
context.popScreen(result: data)
context.argument<T>()          // typed route argument
context.valid                  // BuildContext? (null if unmounted)
context.showSnackBar(message: "msg")
context.globalPosition         // Offset
context.renderSize             // Size
```

### StringExt (nullable)
```dart
"".isNullOrEmpty          // true
(null as String?).isNullOrEmpty // true
```

### StringNonNullExt
```dart
"#FF5733".toColor()
"api.com".appendUrlPath("v1") // "api.com/v1"
"1234567".splitMoney           // "1.234.567"
```

### ListExt
```dart
list.getOrNull(index)   // T?
list.firstOrNull / lastOrNull / randomOrNull
list.chunks(3)          // List<List<T>>
list.convert((i, e) => ...) // indexed map → List<G>
list.removeFirst()      // removes & returns first element
list.lastIndex          // length - 1
```

### IntExt
```dart
1700000000000.millisToDateFormat()   // "dd/MM/yyyy"
90.secondsToTimeCountDown            // "01 : 30"
90.secondsToTimeFormatter            // "01:30"
90.toDateTime                        // "dd/MM/yyyy"
5.surroundWithRange(0, 10)           // clamped int
```

### DoubleExt
```dart
3.5.surroundWithRange(0.0, 5.0) // clamped double
```

### DurationExt
```dart
Duration(seconds: 90).toMinuteAndSeconds // "01:30"
```

### ColorExt
```dart
Colors.red.toHex()          // "#ffff0000"
Colors.red.toHex(leadingHashSign: false) // "ffff0000"
```

### RectExt / OffsetExt (Canvas)
```dart
rect.containsRect(other)          // strict containment
rect.copy(left: 0, top: 0)

offset.angleWith(other)           // radians
offset.rotate(radians)
offset.normalize()
offset.divBySize(size) / timesBySize(size) / divByOther(other)
```

### DateTimeExt
```dart
DateTime.now().areTheSameDayWith(other) // bool — same year+month+day
```

### FileExt
```dart
file.moveTo(newPath)           // copy + delete
file.extension                 // "png"
file.name                      // "photo.png"
file.nameWithoutExtension      // "photo"
```

### StreamExt / BSExt
```dart
controller.addSafety(value)
bSubject.addSafety(value, allowDuplicate: false) // skips closed + duplicate
bSubject.addErrorSafety(error)
```

### DI helper (ext/di.dart)
```dart
appInject<T>()       // synchronous GetIt lookup
appInjectAsync<T>()  // async GetIt lookup
```

---

## 10. Utilities

### NetWorkChecker (`@singleton`)
```dart
final checker = appInject<NetWorkChecker>();
checker.isNetworkAvailable             // bool
checker.networkAvailableStream         // Stream<bool>
checker.invokeWithNetWorkChecker(context,
  onNetworkAvailable: () { ... },
  onNetworkConnectFailed: () { ... });
```

### DirManager
```dart
final path = await DirManager.getInternalDir("audio"); // creates if missing
```

### FileLoaderHelper
```dart
final data = await FileLoaderHelper.getFileOrAssets("assets/data/file.json");
// If path starts with "assets/" returns ByteData from rootBundle, else returns path string
```

### TransitionHelper
```dart
TransitionHelper.buildSlideTransition(curve: Curves.easeIn)
TransitionHelper.buildRouteTransition((anim, child) => FadeTransition(...))
// Used internally by RouterCreator; reuse for custom PageRouteBuilder
```

### CrashlyticsLogger
```dart
CrashlyticsLogger.logError("screen_name"); // dedupes consecutive identical calls
```

### Dev
```dart
Dev.log("debug message"); // no-op stub — replace with real logging if needed
```

### Constants / AppIds / Event
```dart
Constants.defaultSupportEmail
Constants.privacyPolicyUrl
Constants.appIds.androidAppStore
Event.openSound // analytics event name
```

### PermissionHelper
```dart
final granted = await PermissionHelper.checkPermissionSupport(
  [Permission.microphone],
  openAppSetting: () async => openAppSettings(),
);
```

### RectRotated / Point (Math)
Rotatable polygon for collision detection (SAT algorithm).
```dart
final rect = RectRotated.fromLTWH(x, y, w, h);
rect.rotate(0.5);                    // rotate in-place
rect.overlaps(other)                 // bool — SAT collision test
rect.contains(Offset(x, y))         // bool — point-in-polygon
```
