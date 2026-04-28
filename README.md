# InterCommerce App — Prueba Técnica Flutter

## Arquitectura y patrones

El proyecto sigue **Clean Architecture** con separación estricta en tres capas por módulo (`product_catalog`, `product_detail`, `cart`):

- **Data**: datasources (API remota / SQLite local), modelos con `freezed` + `json_serializable`, implementaciones de repositorios.
- **Domain**: entidades puras de negocio (sin dependencias externas), interfaces de repositorio, use cases con toda la lógica de negocio (cálculo de `discountedPrice`, totales).
- **Presentation**: páginas (`ConsumerWidget`), notifiers de Riverpod con patrón **Event/State** (sealed classes), providers.

**Patrones y librerías clave:**

- **Riverpod** (`NotifierProvider` / `NotifierProvider.family`): cada controlador expone un método `add(Event)` que despacha a handlers privados mediante `switch` sobre sealed classes. Estados posibles: `Loading`, `Success`, `Error`.
- **GetIt**: service locator para inyección de dependencias. Cada módulo registra sus dependencias en su propio `injectionContainer`.
- **GoRouter**: navegación declarativa con rutas nombradas. El id del producto se pasa como `pathParameter`.
- **freezed**: inmutabilidad y serialización JSON en los modelos de la capa `data`. Las entidades de dominio son clases Dart puras sin dependencias externas.
- **Dio**: cliente HTTP con manejo centralizado de errores (`CustomException`) para timeouts, errores de red y respuestas 4xx/5xx.
- **sqflite**: persistencia del carrito en SQLite (tabla `cart`). El carrito sobrevive al cierre de la app.
- **SharedPreferences**: caché offline del catálogo. Si falla la red, se sirven los últimos productos guardados.

---

## Instrucciones para ejecutar la app y los tests

**Requisitos:** Flutter SDK `^3.11.4`, dispositivo o emulador conectado.

```bash
flutter pub get
flutter run
```

Si se modifican modelos con `freezed`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Tests (110 en total — unitarios e integración):**

```bash
# Todos los tests
flutter test --concurrency=1

# Solo unitarios
flutter test test/features/cart/domain/use_cases/unit_test/ \
            test/features/cart/presentation/controllers/cart_controller/unit_test/ \
            test/features/product_catalog/domain/use_cases/unit_test/ \
            test/features/product_catalog/presentation/controllers/product_catalog_contoller/unit_test/ \
            test/features/product_detail/domain/use_cases/unit_test/ \
            test/features/product_detail/presentation/controllers/product_detail_controller/unit_test/

# Solo integración (requieren internet para los tests de API)
flutter test test/features/cart/domain/use_cases/integration_test/ \
            test/features/product_catalog/domain/use_cases/integration_test/ \
            test/features/product_detail/domain/use_cases/integration_test/ \
            --concurrency=1
```

---

## Supuestos técnicos

1. **Entorno único**: no se implementó sistema de flavors. La configuración apunta directamente a `https://dummyjson.com`.

2. **Caché offline parcial**: `SharedPreferences` persiste solo la primera página del catálogo. La paginación adicional no se guarda offline.

3. **Sin autenticación**: la API no requiere tokens, por lo que no se implementó almacenamiento seguro de credenciales.

4. **Entidades de dominio sin `freezed`**: las entidades son clases Dart puras de forma intencional; `freezed` se usa solo en los modelos de la capa `data` para no introducir dependencias externas en el dominio.

5. **`discountedPrice` calculado en el use case**: el campo no viene de la API. Se calcula como `price * (1 - discountPercentage / 100)` redondeado a 2 decimales. No se aplican impuestos adicionales al no estar definidos en el contrato de la API.

6. **Tests de integración SQLite con `--concurrency=1`**: múltiples isolates accediendo al mismo archivo SQLite en paralelo generan condiciones de carrera; la bandera lo evita.
