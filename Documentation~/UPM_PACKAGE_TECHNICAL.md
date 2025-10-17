# Google Sign-In UPM Package - Технічна документація

**Останнє оновлення:** 2025-10-17

---

## 📦 СТРУКТУРА ПАКЕТУ

```
google-signin-unity/
├── package.json                    # UPM manifest в корені
├── README.md, CHANGELOG.md, LICENSE
│
├── Runtime/                        # C# Runtime код
│   ├── Google.SignIn.asmdef        # Assembly Definition
│   ├── GoogleSignIn.cs
│   ├── GoogleSignInConfiguration.cs
│   ├── GoogleSignInUser.cs
│   └── ... (інші C# файли)
│
├── Editor/                         # Editor код та dependencies
│   ├── GoogleSignInDependencies.xml
│   ├── GoogleSignInSupportDependencies.xml
│   └── m2repository/               # Maven repo з .aar
│       └── com/google/signin/google-signin-support/1.0.4/
│           ├── google-signin-support-1.0.4.aar
│           ├── google-signin-support-1.0.4.pom
│           └── ...
│
├── Plugins/                        # Native код
│   └── iOS/GoogleSignIn/
│       ├── GoogleSignIn.mm
│       └── GoogleSignInAppController.mm  # + Unity 6 fix
│
└── *.meta файли                    # Всі .meta файли закомічені в Git
```

---

## 🔑 КЛЮЧОВІ МОМЕНТИ

### 1. UPM Package Structure

✅ **package.json в корені** - Unity може завантажити пакет напряму з Git без `?path=`

```json
"com.google.signin": "https://github.com/GooDimuch/google-signin-unity.git#upm-package"
```

### 2. .meta файли ОБОВ'ЯЗКОВІ для Git-based UPM

| Джерело | .meta файли |
|---------|-------------|
| `Assets/` (локально) | Unity генерує автоматично |
| `Packages/` (з Git) | **Потрібні в репозиторії!** ✅ |

**Без .meta файлів Unity не бачить пакет!**

### 3. Assembly Definition Files

✅ **Runtime/Google.SignIn.asmdef** - щоб Unity компілював C# код в окремий assembly

**Без .asmdef:**
- ❌ `using Google;` не працює
- ❌ Compilation errors

**З .asmdef:**
- ✅ `using Google;` працює
- ✅ Namespace resolution працює

### 4. Native Android Library

✅ **Editor/m2repository/** містить `google-signin-support-1.0.4.aar`

**Що це:**
- Pre-compiled `.aar` з native `.so` бібліотеками (libnative-googlesignin.so)
- EDM4U копіює в `Assets/GeneratedLocalRepo/`
- Включається в APK білд автоматично

**Без .aar:**
- ❌ `DllNotFoundException: Unable to load DLL 'native-googlesignin'`

**З .aar:**
- ✅ Native library працює

---

## 🚀 ЯК ПРАЦЮЄ ІНТЕГРАЦІЯ

### 1. Додаємо в manifest.json:
```json
"com.google.signin": "https://github.com/GooDimuch/google-signin-unity.git#upm-package"
```

### 2. Unity завантажує:
```
Library/PackageCache/com.google.signin@[hash]/
```

### 3. Unity читає:
- ✅ `package.json` - metadata пакету
- ✅ `.meta файли` - GUID для кожного файлу
- ✅ `Google.SignIn.asmdef` - assembly definition
- ✅ `GoogleSignInDependencies.xml` - Android dependencies

### 4. EDM4U резолвить:
- ✅ `play-services-auth:21.2.0`
- ✅ `google-signin-support:1.0.4` (з локального m2repository)
- ✅ Копіює `.aar` в `Assets/GeneratedLocalRepo/`

### 5. Unity компілює:
- ✅ C# код в `Google.SignIn.dll`
- ✅ Namespace `Google` доступний

### 6. Білд APK:
- ✅ `.aar` включається в білд
- ✅ Native `.so` розпаковується в APK
- ✅ Java код працює

---

## ⚠️ ВАЖЛИВІ ПРАВИЛА

### 1. Assets/GeneratedLocalRepo/ - НЕ КОМІТИТИ

Цю директорію генерує EDM4U, додай в `.gitignore`:

```gitignore
Assets/GeneratedLocalRepo/
```

### 2. .meta файли в пакеті - ОБОВ'ЯЗКОВО КОМІТИТИ

Для Git-based UPM пакетів `.meta` файли **потрібні** в репозиторії.

### 3. GUID конфлікти

Якщо GUID в `Runtime.meta` конфліктує з проектом - змінити GUID:

```yaml
fileFormatVersion: 2
guid: 2a0340569ab0e1245a38e0d6c7b2529b  # Змінений GUID
folderAsset: yes
```

---

## 📚 ДОВІДКА

### Структура .meta файлів:

**Директорія:**
```yaml
fileFormatVersion: 2
guid: 8a7c4f3e9b2d4e1a8c5f6d7e9a1b2c3d
folderAsset: yes
DefaultImporter:
  externalObjects: {}
```

**C# файл:**
```yaml
fileFormatVersion: 2
guid: 1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e
MonoImporter:
  serializedVersion: 2
  defaultReferences: []
  executionOrder: 0
```

**Assembly Definition:**
```json
{
  "name": "Google.SignIn",
  "references": ["Unity.Tasks", "Unity.Compat"],
  "autoReferenced": true
}
```

---

## 🔧 TROUBLESHOOTING

### Unity не бачить пакет
**Причина:** Відсутні .meta файли або package.json не в корені

**Рішення:** Перевірити що використовується гілка `upm-package`

### `using Google;` не працює
**Причина:** Відсутній `Google.SignIn.asmdef`

**Рішення:** Force reimport пакету

### `DllNotFoundException: native-googlesignin`
**Причина:** Відсутній `.aar` в `m2repository`

**Рішення:** Force Resolve Android Dependencies

---

## 📋 CHECKLIST ДЛЯ НОВОГО ПАКЕТУ

Якщо створюєш новий UPM пакет з Git:

- [ ] `package.json` в корені
- [ ] `Runtime/` директорія з C# кодом
- [ ] `Runtime/YourPackage.asmdef` файл
- [ ] Всі `.meta` файли закомічені
- [ ] `Editor/` з Dependencies.xml (якщо потрібно)
- [ ] `Plugins/` з native кодом (якщо потрібно)
- [ ] `README.md` з інструкціями
- [ ] `CHANGELOG.md` з версіями
- [ ] `.gitignore` для тимчасових файлів

---

_Документація створена: 2025-10-17_  
_Компактна версія замість 4-х детальних документів_

