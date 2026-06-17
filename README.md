# Demo Ecommerce App

Flutter + GetX diye banano simple ecommerce demo app.

## Ei update-e ki fix kora hoyeche

- Splash/onboarding screen-er huge blank space fix kora hoyeche.
- Image layout responsive kora hoyeche, tai screen size change holeo image beshi niche chole jabe na.
- Dot indicator-er jonno `smooth_page_indicator` package use kora hoyeche.
- Network image load/cache korar jonno `cached_network_image` package use kora hoyeche.
- Image load hote deri hole loading spinner dekhabe, error hole fallback icon dekhabe.
- Splash screen fully animated kora hoyeche: title/text entry, image floating, button shimmer, animated background, page transition.

## Latest bug fix: multiple ScrollController attach

Problem:

```text
ScrollController attached to multiple scroll views.
```

Keno hocchilo:

- Age `PageController` GetX `SplashController` class-er vitore chilo.
- GetX controller screen-er cheye beshi time alive thakte pare.
- Splash screen rebuild/reopen hole same `PageController` abar notun `PageView`-e attach hocchilo.
- Ekta `PageController` ek sathe multiple `PageView`/scroll view control korle Flutter assertion throw kore.

Ki move kora hoyeche:

- `PageController` ke `SplashController` theke remove kora hoyeche.
- `PageController` ke `SplashView` er local `State` er moddhe rakha hoyeche.
- `initState()` er moddhe new `PageController()` create hoy.
- `dispose()` er moddhe `_pageController.dispose()` call hoy.
- Dot click ar Continue button-er next-page animation local `_pageController` diye control hoy.
- Last splash page-e gele `controller.finishSplash()` call kore `/home` route-e jay.

Future rule:

- `TextEditingController`, `PageController`, `ScrollController`, `AnimationController` er moto UI lifecycle object usually widget `State` er moddhe rakha better.
- GetX controller-e only business logic/data rakho, jemon current page index, API data, route action.
- Same controller instance multiple widget-e attach korte dio na.

## Pub.dev package add korar niyom

Package add korar easiest way:

```bash
flutter pub add package_name
```

Example:

```bash
flutter pub add smooth_page_indicator
flutter pub add cached_network_image
```

Manual way:

1. `pubspec.yaml` file open koro.
2. `dependencies:` er niche package name add koro.
3. Terminal-e run koro:

```bash
flutter pub get
```

Ei project-e add kora package:

```yaml
dependencies:
  cached_network_image: ^3.4.1
  smooth_page_indicator: ^2.0.1
```

## Package gulo keno use kora hoyeche

`smooth_page_indicator`:
PageView-er dot indicator sundor animation shoho show kore. Manual `AnimatedContainer` diye dot bananor cheye clean ebong customizable.

`cached_network_image`:
Internet theke image load kore cache kore rakhe. Placeholder, loading state, ar error widget easily deya jay.

## Run korar step

```bash
flutter pub get
flutter run
```

Code check korte:

```bash
flutter analyze
```

Format korte:

```bash
dart format .
```

## Important files

- Splash UI: `lib/app/modules/Splash/views/splash_view.dart`
- Splash logic/controller: `lib/app/modules/Splash/controllers/splash_controller.dart`
- Dependencies: `pubspec.yaml`
