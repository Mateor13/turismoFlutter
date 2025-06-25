# Sitios Turísticos 🏖️

## Generación de APK y Firma

### 1. Crear Keystore (Solo la primera vez)

```bash
keytool -genkey -v -keystore directorio -keyalg RSA -keysize 2048 -validity 10000 -alias alias-de-la-firma
```

### 2. Configurar key.properties 

Crea el archivo `key.properties` en la carpeta de android con:

```properties
storePassword=tu_store_password
keyPassword=tu_key_password
keyAlias=alias-de-la-firma
storeFile=directorio_con_la_ruta_absoluta_del_archivo
```

### 3. Cambiar el build.gradle.kts

Se cambia en el archivo `build.gradle.kts` que esta en la carpeta android/app

Importar al comienzo del archivo:

```
import java.util.Properties
```

*Antes de BuildTypes*

```
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(keystorePropertiesFile.inputStream())
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }
```

Se cambia el buildTypes del build.gradle.kts por esto:

```
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

```

### 4. Generar APK

Para generar el APK firmado:

```bash
# APK de release (firmado)
flutter build apk --release

```

