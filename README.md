# Pruebas API automatizadas (pruebasAPI_UX)

**Resumen**

Este proyecto contiene pruebas automatizadas para validar endpoints HTTP usando Robot Framework y archivos de datos en formato YAML. Proporciona una forma reproducible y parametrizable de ejecutar validaciones de endpoints en distintos ambientes (QA, PROD, etc.), comparado con pruebas manuales ad-hoc.

**Cómo funciona**

- El conjunto de pruebas está en la carpeta `tests/` (por ejemplo `tests/filters_plp.robot`).
- Los datos y configuraciones por ambiente se encuentran en `data/` (por ejemplo `base_urls.yaml`, `filters_plp.yaml`, `sizeapp.yaml`).
- `run_tests.py` orquesta la ejecución; las dependencias figuran en `requirements.txt`.
- Las palabras clave de HTTP y utilidades están en `resources/` y `libraries/`.
- Los resultados se generan en `results/` y en archivos `output_*.xml`, `report_*.html`, `log_*.html`.

**Instalación y ejecución rápida**

1. Crear un entorno virtual e instalar dependencias:

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
pip install -r requirements.txt
```

2. Ejecutar las pruebas (opciones):

```bash
# Ejecutar el runner personalizado
python run_tests.py

# O ejecutar Robot Framework directamente
robot -d results tests/filters_plp.robot
```

**Formato de archivos YAML y cómo parametrizar ambientes/endpoints**

Coloque archivos YAML en `data/`. El proyecto está diseñado para leer archivos YAML que describen:
- URLs base por ambiente
- filtros/parametrizaciones por endpoint
- mapeos de payloads o headers

Ejemplo genérico de YAML (formato sugerido):

```yaml
environment:
  name: qa
  base_url: https://api-qa.example.com

endpoints:
  - id: filters_plp
    path: /products/filters
    method: GET
    query:
      category: shoes
      size: 42
    headers:
      Accept: application/json

  - id: sizeapp
    path: /sizes
    method: POST
    headers:
      Content-Type: application/json
    body_file: payloads/size_request.json
```

Con este diseño puede añadir cualquier ambiente o endpoint simplemente creando un nuevo YAML compatible y referenciándolo desde las pruebas.

**Ventajas frente a pruebas manuales**

- Reproducibilidad: las mismas entradas producen los mismos resultados, eliminando variabilidad humana.
- Rapidez: ejecuciones automáticas permiten validar rápidamente regresiones tras cambios.
- Cobertura y repetición: se pueden ejecutar cientos de combinaciones (endpoints, ambientes, payloads).
- Integración CI: los resultados en XML/HTML facilitan la integración en pipelines (Jenkins, GitLab CI, GitHub Actions).
- Auditoría: los logs y reportes guardan la historia de ejecuciones.

**Limitantes**

- No sustituye pruebas exploratorias manuales: validaciones UI/experiencia o casos ad-hoc pueden requerir inspección humana.
- Requiere mantener los YAML y los casos: datos obsoletos producen falsos positivos/negativos.
- Dependencia de la infraestructura: problemas de red o servicios externos pueden generar flakiness.
- Alcance: la suite valida contratos y respuestas esperadas, pero no detecta problemas internos no expuestos por el API.

**Escalabilidad**

- Añadir endpoints: crear nuevos bloques en YAML y agregar casos en `tests/` o parametrizarlos para leer listas.
- Múltiples ambientes: mantener archivos `base_urls.yaml`, `base_urls_qa.yaml`, `base_urls_prod.yaml` y seleccionar el correcto al correr.
- Ejecución paralela: integrar PyBot/Robot con ejecución paralela (p.ej. `pabot` para Robot) para reducir tiempo en suites grandes.
- Datos dinámicos: usar fábricas de datos o generadores para evitar duplicación y escalar combinaciones.

**Probando cualquier conjunto de ambientes, endpoints y métodos**

El proyecto soporta parametrización mediante YAML. Para probar un conjunto arbitrario:

1. Crear un YAML con múltiples `environment` o múltiples `endpoints`.
2. Pasar la referencia al `run_tests.py` (o configurar la variable de entorno) para seleccionar el archivo.
3. Las pruebas leen el YAML y ejecutan cada endpoint con su método correspondiente (GET, POST, PUT, DELETE) usando los headers, query y body especificados.

Ejemplo de flujo para añadir un nuevo ambiente y endpoint:

- Añadir `data/base_urls_staging.yaml` con la URL base.
- Añadir `data/new_endpoints.yaml` describiendo rutas, métodos y payloads.
- Modificar (o parametrizar) `tests/*.robot` para consumir `new_endpoints.yaml` o usar una fixture que itere los endpoints.

**Buenas prácticas y recomendaciones**

- Mantener los YAML pequeños y descriptivos: separar `environments`, `endpoints` y `payloads` en archivos si crecen.
- Versionar ejemplos de payloads (`data/payloads/`) y mantener contratos (OpenAPI) sincronizados.
- Ejecutar en CI con `pip install -r requirements.txt` y publicar los `report.html` como artefactos.
- Añadir pruebas de contrato (schema validation) además de validaciones de campo.

**Estructura de carpetas (resumen)**

- `data/` — archivos YAML de configuración y datos.
- `tests/` — pruebas Robot Framework.
- `resources/` — recursos compartidos y keywords Robot.
- `libraries/` — utilidades Python (p.ej. `excel_writer.py`).
- `results/` — resultados de ejecución.
- `run_tests.py` — script de orquestación.
