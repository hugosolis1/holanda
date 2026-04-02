# Instrucciones de Configuración

## Opción 1: Abrir directamente en Xcode (Recomendado)

1. Abre el archivo `PlanetaryEphemeris.xcodeproj` en Xcode 15.0+
2. Conecta tu dispositivo iOS o selecciona un simulador (iOS 15.0+)
3. Presiona `Cmd+R` para compilar y ejecutar

**Nota**: Esta versión usa cálculos astronómicos nativos y no requiere dependencias externas.

## Opción 2: Crear proyecto desde cero (si hay problemas)

Si el archivo .xcodeproj no funciona correctamente, puedes crear uno nuevo:

1. En Xcode: File → New → Project
2. Selecciona "App" bajo la pestaña iOS
3. Configura:
   - Product Name: `PlanetaryEphemeris`
   - Interface: `SwiftUI`
   - Language: `Swift`
4. Guarda en una carpeta temporal
5. Copia todos los archivos `.swift` de `PlanetaryEphemeris/` a tu nuevo proyecto
6. Agrega la dependencia de Swiss Ephemeris:
   - File → Add Package Dependencies
   - Busca: `https://github.com/alphavalleyfork/SwissEphemeris.git`
   - Selecciona versión 0.2.0 o superior
7. Compila y ejecuta

## Configuración de CodeMagic

1. Sube el repositorio a GitHub
2. Ve a https://codemagic.io e inicia sesión con tu cuenta de GitHub
3. Crea una nueva app seleccionando tu repositorio
4. CodeMagic detectará automáticamente el archivo `codemagic.yaml`
5. Ve a "Start new build" para compilar el IPA

### Importante para CodeMagic

El archivo `codemagic.yaml` está configurado para:
- Usar Xcode 15.0 en Mac Mini M1
- Compilar en modo Release para iOS
- Generar un IPA sin firmar (unsigned)
- Subir el resultado como artifact descargable

## Notas sobre Swiss Ephemeris

Swiss Ephemeris es una librería C de alta precisión. El package `SwissEphemeris` de Swift es un wrapper que la hace accesible desde Swift.

La precisión de los cálculos:
- Planetas: ±0.001 segundos de arco
- Luna: ±0.01 segundos de arco
- Rango: 3000 BC a 3000 AD

## Solución de Problemas

### Error: "No such module 'SwissEphemeris'"

1. En Xcode, selecciona File → Packages → Resolve Package Versions
2. Espera a que se descarguen las dependencias
3. Limpia el build folder: Cmd+Shift+K, luego Cmd+Shift+K nuevamente
4. Compila de nuevo: Cmd+B

### Error: "Cannot find 'swe_calc_ut' in scope"

Este error indica que las funciones de C no están expuestas correctamente. El código incluye wrappers que deberían funcionar. Si persiste:

1. Asegúrate de que SwissEphemeris se descargó correctamente
2. Verifica en File → Packages que la dependencia está resuelta

### Error al crear el IPA

Si CodeMagic falla al crear el IPA:

1. Verifica que el proyecto compila localmente primero
2. Revisa los logs de CodeMagic para errores específicos
3. Asegúrate de que todos los archivos estén commiteados en git

## Estructura de Archivos

```
PlanetaryEphemeris/
├── PlanetaryEphemeris.xcodeproj/    # Proyecto Xcode
├── PlanetaryEphemeris/
│   ├── PlanetaryEphemerisApp.swift  # Punto de entrada
│   ├── Assets.xcassets/             # Recursos gráficos
│   ├── Preview Content/             # Preview de SwiftUI
│   ├── Models/
│   │   ├── PlanetPosition.swift    # Modelos de datos
│   │   └── HouseCusps.swift         # Casas astrológicas
│   ├── Views/
│   │   ├── ContentView.swift       # Vista principal
│   │   ├── PositionView.swift      # Posiciones
│   │   ├── SearchDegreesView.swift # Búsqueda
│   │   └── SettingsView.swift      # Configuración
│   ├── Engine/
│   │   └── SwissEphemerisEngine.swift # Motor astronómico
│   └── Resources/
├── codemagic.yaml                   # CI/CD
├── README.md                        # Documentación
└── SETUP.md                         # Este archivo
```

## Compatibilidad

- iOS 15.0+ (incluye iOS 15.8.2)
- iPadOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Recursos Adicionales

- [Documentación Swiss Ephemeris](https://www.astro.com/swisseph/swephprg.htm)
- [GitHub SwissEphemeris Swift](https://github.com/alphavalleyfork/SwissEphemeris)
- [NASA JPL Ephemerides](https://ssd.jpl.nasa.gov/planets/eph_export.html)
