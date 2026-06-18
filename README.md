# Demo Ecommerce App

Flutter + GetX diye banano simple ecommerce demo app.

## 📱 APK Download (APK ডাউনলোড করার নিয়ম)

আপনি এই অ্যাপটির APK ফাইলটি সরাসরি ডাউনলোড করতে পারবেন। নিচে ডাউনলোড করার উপায়গুলো দেওয়া হলো:

### ১. GitHub Releases থেকে সরাসরি ডাউনলোড (সুপারিশকৃত)
GitHub-এর Release সেকশনে প্রতিটি আপডেটের পর স্বয়ংক্রিয়ভাবে APK আপলোড করা হয়।

1. এই GitHub রিপোজিটরির ডান পাশের **Releases** সেকশনে যান (অথবা [এখানে ক্লিক করুন](../../releases/latest) - *রিপোজিটরি পাবলিশ করার পর কাজ করবে*)।
2. **Assets** সেকশনের নিচে থেকে আপনার মোবাইলের আর্কিটেকচার অনুযায়ী APK ফাইলটি ডাউনলোড করুন:
   - **`demo-ecommerce-universal.apk`**: যেকোনো অ্যান্ড্রয়েড ফোনের জন্য (ফাইলের সাইজ একটু বড় হতে পারে)।
   - **`demo-ecommerce-arm64.apk`**: আধুনিক সব অ্যান্ড্রয়েড ফোনের জন্য (সাইজ ছোট ও দ্রুত কাজ করে)।
   - **`demo-ecommerce-arm32.apk`**: অপেক্ষাকৃত পুরোনো অ্যান্ড্রয়েড ফোনের জন্য।

---

### ২. স্বয়ংক্রিয় GitHub Actions (CI/CD)
এই রিপোজিটরিতে **GitHub Actions** সেটআপ করা আছে। আপনি যখনই `main` বা `master` ব্রাঞ্চে কোনো কোড পুশ করবেন বা কোনো Tag ক্রিয়েট করবেন, এটি অটোমেটিক অ্যাপের APK বিল্ড করে অ্যাকশন আর্টিফ্যাক্ট হিসেবে রেখে দিবে।

- আপনি প্রতিটি কমিটের বা বিল্ডের APK ফাইলটি ডাউনলোড করতে রিপোজিটরির **Actions** ট্যাবে গিয়ে লেটেস্ট রান করা জবটিতে ক্লিক করে নিচে **Artifacts** সেকশন থেকে ডাউনলোড করতে পারবেন।

---

### ৩. নিজের কম্পিউটারে APK বিল্ড করার নিয়ম
আপনি যদি লোকালভাবে নিজের পিসিতে APK তৈরি করতে চান, তবে নিচের ধাপগুলো অনুসরণ করুন:

1. আপনার সিস্টেমে Flutter ইনস্টল থাকতে হবে।
2. টার্মিনাল বা কমান্ড প্রম্পটে প্রজেক্টের রুট ডিরেক্টরিতে যান:
   ```bash
   cd "/path/to/your/project"
   ```
3. ডিপেন্ডেন্সি রিলোড করুন:
   ```bash
   flutter pub get
   ```
4. এবার রিলিজ APK বিল্ড করতে নিচের কমান্ডটি রান করুন:
   - **সব ডিভাইসের জন্য একটি সিঙ্গেল (Universal) APK বিল্ড করতে:**
     ```bash
     flutter build apk --release
     ```
     *(ফাইল লোকেশন: `build/app/outputs/flutter-apk/app-release.apk`)*

   - **সাইজ ছোট করার জন্য আলাদা আলাদা (Split) APK বিল্ড করতে (সুপারিশকৃত):**
     ```bash
     flutter build apk --release --split-per-abi
     ```
     *(ফাইল লোকেশন: `build/app/outputs/flutter-apk/` ফোল্ডারের ভেতর আলাদা APK ফাইল পাবেন)*

---

## Ei update-e ki fix kora hoyeche

- Splash/onboarding screen-er huge blank space fix kora hoyeche.
- Image layout responsive kora hoyeche, tai screen size change holeo image beshi niche chole jabe na.
- Dot indicator-er jonno `smooth_page_indicator` package use kora hoyeche.
- Network image load/cache korar jonno `cached_network_image` package use kora hoyeche.
- Image load hote deri hole loading spinner dekhabe, error hole fallback icon dekhabe.
- Splash screen fully animated kora hoyeche: title/text entry, image floating, button shimmer, animated background, page transition.

## Splash button: Next vs Continue

Last splash page-er button-e **"Continue"** dekhabe, baki page gulo te **"Next"** dekhabe.

Keno:

- User bujhte parbe kothay splash sesh hobe.
- "Next" mane porborti splash page-e jabe.
- "Continue" mane splash sesh kore home screen-e jabe.

Ki kora hoyeche:

- `_ContinueButton` widget-e notun `isLastPage` parameter add kora hoyeche.
- `Obx()` diye button wrap kora hoyeche jate `currentPage` change hole button text auto-update hoy.
- `AnimatedSwitcher` use kora hoyeche jate "Next" → "Continue" text change smooth animation-e hoy.
- Last page detect hoy `controller.currentPage.value == controller.splashData.length - 1` diye.

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

## Tooling/path error fix

Problem:

```text
Unable to get relative path between file:///path/to/your/project/lib/app/modules/Splash/views/splash_view.dart and ; Base path '' must be an absolute path
```

Eta usually Dart/Flutter code-er syntax problem na. Eta IDE/runner project root detect korte na parle hoy.

Keno hoy:

- Single Dart file run korle IDE sometimes project root/base path empty dhore.
- Terminal current folder project root na hole Flutter relative path resolve korte pare na.
- Path copy korar somoy `\lib\...` diye start korle eta absolute path na, tai resolver fail korte pare.

Fix:

1. Android Studio/VS Code-e puro project folder open koro:

```text
/path/to/your/project
```

2. Single file run na kore project root theke run koro:

```bash
flutter run
```

3. Terminal wrong folder-e thakle first project folder-e jao:

```bash
cd "/path/to/your/project"
flutter pub get
flutter run
```

4. File path lagle relative path use koro:

```text
lib/app/modules/Splash/views/splash_view.dart
```

5. Backslash diye root-less path use koro na:

```text
\lib\app\modules\Splash\views\splash_view.dart
```

Karon eta absolute path na. Absolute path hole full drive path thakte hobe:

```text
/path/to/your/project/lib/app/modules/Splash/views/splash_view.dart
```

Extra fix:

- `test/widget_test.dart` file-e valid `main()` smoke test add kora hoyeche, jate `flutter test` missing-main error na dey.

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
