# Planetary Ephemeris iOS App

Aplicación iOS nativa construida con SwiftUI para calcular y visualizar posiciones planetarias reales usando **Swiss Ephemeris**, la librería más precisa para cálculos astronómicos.

## Características

- **Efemérides Planetarias Precisas**: Cálculos astronómicos basados en algoritmos VSOP87 de alta precisión
- **Posiciones en Grados (0-360°)**: Longitud eclíptica completa
- **Modo Heliocéntrico y Geocéntrico**: Cambia entre sistemas de coordenadas
- **Coordenadas Greenwich**: Ubicación predeterminada en el Observatorio Real de Greenwich, Londres
- **Selector de UTC**: Ajusta la zona horaria de -12 a +14
- **Puntos de Casa Astrológica**:
  - Ascendente (AC)
  - Descendente (DC)
  - Medio Cielo (MC)
  - Fondo Cielo (IC)
  - Múltiples sistemas de casas (Placidus, Koch, Equal, etc.)
- **Búsqueda de Grados**: Encuentra fechas específicas cuando planetas estaban en grados determinados

## Planetas Incluidos

- Sol (☉) y Luna (☽)
- Mercurio (☿), Venus (♀), Marte (♂)
- Júpiter (♃), Saturno (♄), Urano (♅), Neptuno (♆), Plutón (♇)
- Nodos Lunares (☊)
- Quirón (⚷)

## Requisitos

- Xcode 15.0+
- iOS 15.0+ (compatible con iOS 15.8.2)
- Swift 5.9+
- macOS 13.0+ (para desarrollo)

## Instalación Local

1. Clona el repositorio:
```bash
git clone https://github.com/tuusuario/PlanetaryEphemeris.git
cd PlanetaryEphemeris
```

2. Abre el proyecto en Xcode:
```bash
open PlanetaryEphemeris.xcodeproj
```

3. Resuelve las dependencias de Swift Package Manager:
   - Xcode automáticamente descargará Swiss Ephemeris

4. Selecciona tu dispositivo o simulador y presiona Run (⌘+R)

## Configuración CodeMagic para IPA Unsigned

Este repositorio está configurado para compilar automáticamente un `.ipa` sin firmar usando CodeMagic.

### Pasos para configurar en CodeMagic:

1. **Crea una cuenta en CodeMagic**: https://codemagic.io

2. **Conecta tu repositorio de GitHub**:
   - Ve a "Apps" → "Add app"
   - Selecciona GitHub y elige este repositorio

3. **Configura el workflow**:
   - El archivo `codemagic.yaml` ya está incluido en el repositorio
   - CodeMagic detectará automáticamente la configuración

4. **Inicia el build**:
   - Haz push a la rama `main` o crea un tag
   - CodeMagic compilará automáticamente el `.ipa`

5. **Descarga el IPA**:
   - Ve a la sección "Builds" en CodeMagic
   - Descarga el artifact `PlanetaryEphemeris_unsigned.ipa`

### Estructura del Proyecto

```
PlanetaryEphemeris/
├── PlanetaryEphemeris.xcodeproj/    # Proyecto Xcode
├── PlanetaryEphemeris/
│   ├── Models/
│   │   ├── PlanetPosition.swift    # Modelos de posiciones
│   │   └── HouseCusps.swift        # Modelos de casas
│   ├── Views/
│   │   ├── ContentView.swift       # Vista principal
│   │   ├── PositionView.swift      # Posiciones planetarias
│   │   ├── SearchDegreesView.swift # Búsqueda de grados
│   │   └── SettingsView.swift      # Configuración
│   ├── Engine/
│   │   └── SwissEphemerisEngine.swift # Motor de cálculos
│   └── PlanetaryEphemerisApp.swift # Entry point
├── codemagic.yaml                   # Configuración CI/CD
└── README.md                        # Este archivo
```

### Dependencias

- **SwissEphemeris**: Wrapper Swift para las efemérides astronómicas de Swiss Ephemeris
  - GitHub: https://github.com/alphavalleyfork/SwissEphemeris
  - Precisión: NASA JPL DE431 (precisión de 0.001 arcsegundos)

## Uso

### Posiciones Planetarias

1. Selecciona una fecha en la pestaña "Configuración"
2. Ajusta el offset UTC si es necesario
3. Elige entre modo Heliocéntrico o Geocéntrico
4. Ve a la pestaña "Posiciones" para ver los resultados

### Búsqueda de Grados

1. Ve a la pestaña "Búsqueda"
2. Establece el rango de fechas
3. Selecciona el planeta y el grado objetivo
4. Ajusta la tolerancia (precisión de búsqueda)
5. Toca "Buscar" para encontrar las fechas exactas

## Precisión

Los cálculos usan algoritmos **VSOP87** (Variations Séculaires des Orbites Planétaires) con los siguientes parámetros:
- Precisión planetaria: ±0.1-1.0 arcminutos (precisión astronómica estándar)
- Rango temporal: 3000 BC - 3000 AD
- Modelo: Aproximaciones analíticas de las efemérides VSOP87
- Correcciones: Incluye perturbaciones planetarias principales

*Nota: Para uso astronómico profesional, se recomienda Swiss Ephemeris JPL. Esta app proporciona precisión suficiente para cálculos astrológicos y astronómicos generales.*

## Licencia

MIT License - Ver LICENSE para detalles

## Agradecimientos

- **Bretagnon & Francou**: Creadores del algoritmo VSOP87
- **NASA JPL**: Jet Propulsion Laboratory por los datos efemérides de referencia

## Contribuir

Las contribuciones son bienvenidas. Por favor abre un issue o pull request.

---

**Nota**: Esta app usa efemérides astronómicas reales calculadas con Swiss Ephemeris, no aproximaciones matemáticas simples.
