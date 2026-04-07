# Plan Tecnico de Implementacion Flutter

## Estado
- Diseno visual congelado en Pencil antes de empezar codigo.
- Este documento define la arquitectura, decisiones tecnicas, alcance y orden de implementacion.
- No incluye codigo.

## Objetivo del Producto
SmartFit es una aplicacion de gym para Android hecha en Flutter y Dart, con foco en:
- uso offline y carga rapida
- rutina semanal recurrente
- registro real de sesiones
- historial de fuerza y cardio
- CRUD completo de dias y ejercicios
- soporte para telefono y tablet
- tema claro y oscuro en toda la app
- respaldo local exportable e importable

## Decision Clave de Dominio
La app no debe modelarse solo como una rutina. Debe separar:
- plantilla semanal recurrente
- sesion real por fecha
- historial acumulado

Esto resuelve correctamente:
- checks de series por fecha
- ultimo peso usado como referencia
- progreso real por ejercicio
- graficas historicas
- posibles integraciones futuras con datos de salud

## Alcance V1
### Incluye
- Home con lo que toca hoy
- Semana con solo dias creados
- dias de entrenamiento y descanso
- detalle de dia de entrenamiento
- ejercicios de fuerza
- bloques de cardio manual
- CRUD completo de dias y ejercicios
- copiar, mover y reordenar
- checks por serie
- registro real de peso hecho
- ultimo peso usado como referencia visual
- tema claro y oscuro
- progreso de fuerza y cardio
- backup local exportar/importar
- layouts tablet

### Queda para V2 o posterior
- integracion con Android Health Connect
- importacion automatica de cardio desde reloj o apps compatibles
- sincronizacion en nube
- notificaciones o recordatorios
- autenticacion o multiusuario

## Reglas de Producto Congeladas
- La rutina es semanal y recurrente.
- En la UI normal solo se muestran dias creados.
- Los dias no creados no aparecen como placeholders en la semana.
- Dia de descanso no acepta ejercicios.
- Puede haber multiples tarjetas de cardio en un dia.
- Cada tarjeta de cardio representa un unico bloque de actividad.
- En fuerza se guarda el peso realmente hecho.
- Ultimo peso usado se muestra como ayuda, no como valor por defecto.
- Los textos del usuario se normalizan y capitalizan por palabra, preservando siglas validas.
- Al cambiar un dia con contenido a descanso debe haber confirmacion por conflicto.
- Borrados con perdida de datos requieren confirmacion.

## Stack Tecnico Recomendado
### Base
- Flutter estable
- Dart estable
- Android first

### Estado
- Riverpod

Motivo:
- buen control de estado sin acoplar la UI
- facilita testing
- sirve para flujos de CRUD, settings, historial y sesiones en progreso

### Navegacion
- go_router

Motivo:
- rutas declarativas
- soporte limpio para deep links futuros
- facilita layouts adaptativos si luego se separa navegacion tablet

### Persistencia local
- Isar

Motivo:
- muy rapido en lectura y escritura local
- adecuado para app offline-first
- buen rendimiento para historial, filtros y datos recurrentes

### Serializacion y modelos
- freezed + json_serializable

Motivo:
- modelos inmutables
- copyWith robusto
- union/sealed types utiles para distinguir fuerza, cardio y descanso

### Seleccion y compartido de archivos
- file_picker
- path_provider
- share_plus

### Graficas
- fl_chart

### Tipografias
- Space Grotesk
- Plus Jakarta Sans

Recomendacion:
- empaquetarlas como assets para evitar dependencia visual del entorno.

## Arquitectura General
Usar una arquitectura por features con capas internas claras.

### Estructura sugerida
- lib/
- lib/app/
- lib/core/
- lib/features/home/
- lib/features/schedule/
- lib/features/workout_day/
- lib/features/progress/
- lib/features/settings/
- lib/features/backup/
- lib/features/shared/

### Dentro de cada feature
- presentation/
- application/
- domain/
- data/

### Responsabilidad por capa
- presentation: widgets, pantallas, controllers UI, adaptacion responsive
- application: casos de uso, coordinacion, validaciones de flujo
- domain: entidades, value objects, reglas del negocio
- data: repositorios, colecciones Isar, mapeos DTO, import/export

## Modelo de Datos
### Entidades principales
#### WeeklyPlan
Plantilla semanal activa.
Campos:
- id
- createdAt
- updatedAt
- isActive

#### PlanDay
Representa un dia creado dentro de la plantilla semanal.
Campos:
- id
- weeklyPlanId
- weekday
- type: training | rest
- routineName
- orderIndex

Reglas:
- weekday unico dentro del weekly plan
- si type es rest, no puede tener ejercicios

#### ExerciseTemplate
Ejercicio dentro de un PlanDay de entrenamiento.
Campos:
- id
- planDayId
- type: strength | cardio
- orderIndex
- displayName

#### StrengthTemplate
Campos:
- exerciseTemplateId
- targetSets
- targetReps

#### CardioTemplate
Campos:
- exerciseTemplateId
- cardioType
- defaultDurationMinutes opcional
- defaultIncline opcional

Nota:
- el template define estructura, no la ejecucion real.

#### WorkoutSession
Sesion real por fecha.
Campos:
- id
- planDayId
- sessionDate
- sessionStatus: pending | in_progress | completed | skipped
- createdAt
- updatedAt

Reglas:
- una sesion por dia y fecha
- si el dia del plan es rest, puede existir solo como estado informativo, sin ejercicios

#### StrengthSetLog
Registro real por serie en una sesion.
Campos:
- id
- workoutSessionId
- exerciseTemplateId
- setIndex
- performedReps
- performedWeight
- isCompleted
- completedAt opcional

#### CardioLog
Registro real del bloque de cardio.
Campos:
- id
- workoutSessionId
- exerciseTemplateId
- source: manual | imported
- cardioType
- durationMinutes
- incline optional
- distance optional
- calories optional
- averageHeartRate optional

#### AppSettings
Campos:
- id
- themeMode: system | light | dark
- weightUnit: kg | lb
- firstLaunchCompleted
- lastBackupAt opcional
- preferredGraphRange

Valores iniciales congelados:
- appName: SmartFit
- defaultWeightUnit: kg
- defaultThemeMode: system

## Reglas de Historial
- El historial se alimenta de WorkoutSession, StrengthSetLog y CardioLog.
- El ultimo peso usado se calcula desde el registro real mas reciente del mismo ejercicio.
- El ultimo peso usado no rellena automaticamente el campo nuevo.
- Las graficas usan solo registros completados o validados.

## Navegacion Funcional
### Pantallas principales
- Home
- Semana
- Detalle de dia
- Crear o editar dia
- Crear o editar ejercicio de fuerza
- Crear o editar cardio
- Reordenar ejercicios
- Organizar semana
- Progreso
- Ajustes
- Respaldo

### Flujo principal
1. Abrir app
2. Ver lo que toca hoy
3. Entrar a la sesion o crear primer dia
4. Registrar fuerza o cardio
5. Consultar progreso
6. Gestionar ajustes o backup

## Mapeo de Diseño Pencil a Flutter
### Componentes base
- Button/Primary -> AppPrimaryButton
- Button/Secondary -> AppSecondaryButton
- Button/Icon Capsule -> AppIconCapsuleButton
- Selector/Segmented -> AppSegmentedControl
- Card/Day Training -> TrainingDayCard
- Card/Day Rest -> RestDayCard
- Card/Strength Exercise -> StrengthExerciseCard
- Card/Cardio -> CardioExerciseCard
- Sheet/Create Day -> CreateDaySheet
- Sheet/Add Training -> AddTrainingSheet
- Sheet/Edit Training -> EditTrainingSheet
- Sheet/Move Day -> MoveDaySheet
- Sheet/Move Exercise -> MoveExerciseSheet
- Dialog/Delete -> ConfirmDeleteDialog
- Card/Chart -> ProgressChartCard

### Tokens visuales
Centralizar en un sistema de tokens:
- AppColors
- AppSpacing
- AppRadius
- AppElevation
- AppDurations
- AppTypography

### Reglas visuales a mantener
- radios amplios inspirados en continuous corners
- sombras suaves y controladas
- modo dark como default visual de referencia
- version light equivalente, no secundaria
- animaciones cortas de tactilidad

## Responsive y Tablet
### Breakpoints recomendados
- phone: menos de 600 dp
- tablet compacta: 600 a 839 dp
- tablet amplia: 840 dp o mas

### Reglas
#### Home tablet
- columna izquierda: semana
- panel derecho: sesion de hoy

#### Day detail tablet
- columna izquierda: lista de ejercicios
- panel derecho: inspector o editor del ejercicio seleccionado

#### Progress tablet
- dos charts lado a lado
- bloque de resumen debajo

No escalar sin criterio. Redistribuir paneles.

## Microinteracciones
### Estados obligatorios
- normal
- pressed
- disabled
- dragging
- dropTarget
- active
- completed
- destructive

### Comportamiento esperado
- pressed button: ligera compresion visual
- pressed card: baja de elevacion
- dragging: mayor elevacion y separacion del fondo
- drop target: borde y fondo destacados
- completed set: tintado leve + check claro

## CRUD Completo
### Dias
- crear
- editar
- eliminar
- mover a otro weekday disponible
- reordenar en modo organizacion si el layout lo requiere

### Ejercicios
- crear
- editar
- eliminar
- copiar a otro dia
- mover a otro dia
- reordenar dentro del dia

### Confirmaciones requeridas
- borrar ejercicio
- borrar dia con contenido
- cambiar training a rest si hay ejercicios
- importar backup reemplazando datos locales

## Normalizacion de Texto
Todos los strings ingresados por el usuario deben pasar por normalizacion.

### Reglas
- trim de extremos
- colapsar espacios dobles
- capitalizar cada palabra
- preservar siglas conocidas: RDL, HIIT, JM, PR
- no inventar correcciones agresivas
- respetar nombres validos como Lat Pulldown

## Estados Vacios y de Error
### Estados vacios
- sin rutina creada
- hoy sin plan
- dia de entrenamiento vacio
- sin historial
- sin datos de cardio
- sin backups previos si aplica

### Estados de error o conflicto
- cambio a descanso con contenido existente
- backup invalido o incompatible
- intento de duplicar weekday ocupado
- fallo al importar archivo
- fallo al persistir cambios

## Backup e Import/Export
### Exportar
- serializar WeeklyPlan, PlanDay, ExerciseTemplate, WorkoutSession, logs y AppSettings
- generar archivo JSON versionado
- permitir elegir ruta o compartir

### Importar
- seleccionar archivo
- validar version
- validar integridad minima
- mostrar confirmacion antes de reemplazar datos locales

### Requisito
- definir un schemaVersion en el archivo exportado

## Integracion de Salud
### V1
- solo cardio manual

### V2
- Android Health Connect como primera integracion
- solo si los datos llegan al telefono y el usuario concede permisos

Nota:
- no prometer soporte universal para cualquier reloj
- en Android, el camino correcto es Health Connect o proveedores compatibles

## Casos Limite que deben cubrirse
- no existe dia para hoy
- la semana no tiene dias creados
- se intenta usar un weekday ya ocupado
- un dia cambia de entrenamiento a descanso con ejercicios existentes
- se reducen series cuando ya hay logs
- se copia un ejercicio a un dia donde ya existe otro igual
- se elimina un dia y el weekday debe volver a quedar libre
- se edita la rutina mientras la sesion del dia ya esta iniciada
- se importa un backup de version incompatible
- la UI debe mantenerse usable en pantallas pequenas y tablet

## Orden de Implementacion Recomendado
### Fase 0
- bootstrap del proyecto Flutter
- theme tokens
- routing base
- estructura por features

### Fase 1
- modelos de dominio
- colecciones Isar
- repositorios base
- seed o fixtures de desarrollo

### Fase 2
- pantalla Home
- semana y detalle de dia
- CRUD de dias

### Fase 3
- CRUD de fuerza y cardio
- reordenar, copiar y mover ejercicios
- logs reales por sesion

### Fase 4
- progreso y graficas
- ultimo peso usado
- filtros basicos

### Fase 5
- ajustes
- tema claro/oscuro
- backup export/import

### Fase 6
- tablet layouts
- refinamiento UX
- animaciones y estados pressed/dragging

### Fase 7
- pruebas completas
- endurecimiento de edge cases
- preparacion Android release

## Estrategia de Testing
### Unit tests
- reglas de dominio
- normalizacion de texto
- validaciones de weekday unico
- construccion de historial y ultimo peso usado

### Widget tests
- estados vacios
- toggles de tema
- sheets y dialogs
- cards de fuerza y cardio

### Integration tests
- crear semana completa
- registrar entrenamiento
- copiar y mover ejercicio
- exportar e importar backup
- verificar persistencia tras reinicio

## Definiciones para Empezar Codigo
Antes de escribir codigo, dejar cerrados estos puntos:
- nombre final de la app: SmartFit
- unidades por defecto: kg
- formato exacto de cardio manual
- alcance exacto de backup inicial
- tema default: system

### Formato exacto de cardio manual
Definicion congelada para V1:
- tipo de cardio
- duracion en minutos
- inclinacion opcional
- source = manual

No se incluyen en la V1 manual:
- distancia
- calorias
- frecuencia cardiaca media

Estos campos quedan reservados para importacion futura o una expansion posterior si hace falta.

## Recomendacion Final
La implementacion debe empezar por dominio y persistencia, no por las pantallas mas complejas. La razon es simple:
- la separacion plantilla vs sesion real es la base del producto
- progreso, ultimo peso usado, backup y edge cases dependen de eso
- si esa base sale mal, la UI luego se llena de parches

## Entregable de esta fase
- Diseno visual congelado en Pencil
- Documento tecnico de implementacion listo
- Aun no se ha escrito codigo de Flutter
