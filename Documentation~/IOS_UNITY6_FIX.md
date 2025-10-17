# iOS Unity 6 Build Fix

**Останнє оновлення:** 2025-10-17

---

## 🎯 ПРОБЛЕМА

Unity 6 видалив **deprecated iOS API:**
```objectivec
application:openURL:sourceApplication:annotation:
```

**Результат:** Build error при спробі swizzle неіснуючий метод.

---

## ✅ РІШЕННЯ

**Файл:** `Plugins/iOS/GoogleSignIn/GoogleSignInAppController.mm`

**Зміни (17 рядків):**

```objectivec
// Додано import
+#import <GoogleSignIn/GoogleSignIn.h>

// Додано перевірку перед swizzling
original = class_getInstanceMethod(
    self, @selector(application:openURL:sourceApplication:annotation:));

+if (original) {  // ← Перевірка чи існує метод
    swizzled = class_getInstanceMethod(
        self, @selector(GoogleSignInAppController:openURL:sourceApplication:annotation:));
    method_exchangeImplementations(original, swizzled);
+}
```

**Суть:** Якщо deprecated метод існує (Unity < 6) → swizzle. Якщо ні (Unity 6+) → пропустити.

---

## 📦 СТАТУС В ФОРКУ

**Гілка:** `unity6-ios-fix-upm`  
**Статус:** ⚠️ Готовий, але **НЕ ПРОТЕСТОВАНИЙ** на Unity 6

**Чому не в main гілці:**
- Android працює на гілці `upm-package`
- iOS патч в окремій гілці `unity6-ios-fix-upm`
- Після тестування iOS - merge в `upm-package`

---

## 🚀 ЯК ПРОТЕСТУВАТИ

### 1. Змінити гілку в manifest.json:

```json
"com.google.signin": "https://github.com/GooDimuch/google-signin-unity.git#unity6-ios-fix-upm"
```

### 2. Restart Unity

### 3. Build для iOS

```
File → Build Settings → iOS → Build
```

### 4. Перевірити:

- ✅ Білд компілюється без помилок
- ✅ Google Sign-In працює
- ✅ Можна авторизуватись

---

## 📋 СУМІСНІСТЬ

| Unity Version | Статус |
|---------------|--------|
| Unity 2022.3 | ✅ Працює (backward compatible) |
| Unity 6 | ⚠️ Має працювати (не протестовано) |

---

## 🔗 ПОСИЛАННЯ

- **Гілка з патчем:** https://github.com/GooDimuch/google-signin-unity/tree/unity6-ios-fix-upm
- **Базується на:** `googlesamples/google-signin-unity` v1.0.4

---

_Компактна версія замість детального аналізу_

