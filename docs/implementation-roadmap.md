# Roadmap de Implementacion SmartFit

## Estado
- Este documento define el orden real de ejecucion antes de escribir codigo.
- Complementa el documento tecnico principal.
- No contiene codigo.

## Objetivo
Implementar SmartFit en Flutter sin improvisacion, minimizando retrabajo y evitando que la UI dependa de decisiones de datos mal resueltas.

## Principio Rector
El orden correcto no es "primero pantallas". El orden correcto es:
1. reglas de dominio
2. persistencia y contratos
3. shell de app y design system
4. features principales
5. historico y progreso
6. backup, responsive y refinamiento
7. QA final y release

La razon es simple:
- la app depende de separar plantilla semanal, sesion real e historial
- si esa base no queda bien, se rompen checks, ultimo peso usado, graficas, backup y edge cases

## Dependencias Globales
Antes de empezar una fase, validar siempre estas dependencias:
- decisiones de producto congeladas
- componentes y flujos ya definidos en Pencil
- nombres de entidades y relaciones sin contradicciones
- criterio de salida de la fase anterior cumplido

## Pendientes Menores Antes de Codigo
No hay bloqueos funcionales mayores. Solo conviene confirmar al inicio de la implementacion:
- alcance exacto del backup inicial: se recomienda incluir plan semanal, ejercicios, sesiones, logs y settings
- convencion final de nombres internos en ingles para entidades y directorios

## Vista General de Fases
- Fase 0: Preparacion del proyecto
- Fase 1: Dominio y reglas del negocio
- Fase 2: Persistencia local y repositorios
- Fase 3: Shell de app y traduccion del design system
- Fase 4: Semana y CRUD de dias
- Fase 5: Sesion diaria y CRUD de ejercicios
- Fase 6: Reordenar, mover, copiar y conflictos
- Fase 7: Historial, progreso y ultimo peso usado
- Fase 8: Ajustes, tema y backup
- Fase 9: Tablet, microinteracciones y refinamiento UX
- Fase 10: QA total, endurecimiento y release prep

## Fase 0 - Preparacion del Proyecto
### Objetivo
Levantar una base de proyecto que no obligue a reestructurar todo despues.

### Trabajo
- crear el proyecto Flutter base
- configurar estructura por features
- instalar dependencias principales
- definir lints y formato
- crear shell inicial de app
- configurar fuentes y assets base
- definir tokens visuales del design system
- preparar go_router y routing inicial vacio
- preparar Riverpod como sistema de estado

### Nota tecnica
El tooling de generacion de codigo para modelos y persistencia se difiere a Fase 1.
Motivo:
- en Fase 0 todavia no hay modelos definitivos
- evita bloquear el bootstrap por conflictos de versiones innecesarios
- permite introducir Isar y serializacion cuando ya exista el dominio real

### Decisiones a fijar aqui
- nombres de paquetes
- organizacion exacta de directorios
- convencion de nombres de widgets y providers
- idioma base del codigo: recomendado ingles

### Entregables
- proyecto compila en Android
- theme base light y dark disponibles
- tipografias cargadas
- rutas base creadas
- estructura por features aplicada

### No hacer aun
- logica real de negocio
- persistencia definitiva de features
- pantallas complejas finales

### Criterio de salida
- app arranca
- tokens visuales centrales existen
- se puede crear una pantalla placeholder por feature sin deuda estructural

## Fase 1 - Dominio y Reglas del Negocio
### Objetivo
Modelar el problema correctamente antes de guardar o mostrar datos reales.

### Trabajo
- definir entidades de dominio
- definir value objects y enums
- congelar relaciones entre plan semanal, dia, ejercicio y sesion
- definir reglas de unicidad por weekday
- definir reglas para day type training o rest
- definir contratos para ultimo peso usado
- definir contratos para sesiones y logs reales
- definir normalizacion de texto de entrada

### Entidades que deben quedar listas
- WeeklyPlan
- PlanDay
- ExerciseTemplate
- StrengthTemplate
- CardioTemplate
- WorkoutSession
- StrengthSetLog
- CardioLog
- AppSettings

### Riesgos si se hace mal
- checks persistentes incorrectos
- graficas inconsistentes
- dias repetidos
- copia o movimiento rompiendo relaciones

### Criterio de salida
- modelo de dominio documentado y estable
- edge cases principales resueltos a nivel de reglas
- tests unitarios del dominio planteados

## Fase 2 - Persistencia Local y Repositorios
### Objetivo
Persistir el dominio sin contaminar la UI con detalles de almacenamiento.

### Trabajo
- definir schemas de Isar
- crear mapeos dominio <-> almacenamiento
- implementar repositorios base
- definir indices utiles para consultas por fecha, weekday y ejercicio
- preparar seed de desarrollo con datos de ejemplo
- decidir estrategia de migraciones de schema

### Casos que deben resolverse aqui
- obtener lo que toca hoy
- listar solo dias creados
- obtener ultimo peso usado de un ejercicio
- guardar una sesion por fecha y dia
- reordenar elementos preservando orderIndex
- exportar datos serializables

### Criterio de salida
- CRUD de entidades posible desde repositorios
- datos sobreviven reinicio de app
- consultas clave tienen forma final

## Fase 3 - Shell de App y Traduccion del Design System
### Objetivo
Traducir Pencil a componentes Flutter reutilizables antes de construir features completas.

### Trabajo
- crear sistema de tokens visuales
- crear botones, segmented controls, cards, dialogs y sheets base
- crear wrappers de layout responsive
- definir componentes para estados vacios y error
- implementar variantes light y dark
- crear estados visuales pressed, dragging y drop target a nivel de widgets base

### Componentes prioritarios
- AppPrimaryButton
- AppSecondaryButton
- AppIconCapsuleButton
- AppSegmentedControl
- TrainingDayCard
- RestDayCard
- StrengthExerciseCard
- CardioExerciseCard
- AppBottomSheetScaffold
- AppConfirmDialog
- ProgressChartCard

### Criterio de salida
- biblioteca UI reutilizable estable
- mismas piezas sirven para mobile y tablet
- UI base ya se parece a Pencil sin hacks por pantalla

## Fase 4 - Semana y CRUD de Dias
### Objetivo
Hacer funcional la estructura semanal completa.

### Trabajo
- Home con estado vacio y estado con dia actual
- vista de semana con solo dias creados
- crear dia training o rest
- editar dia
- eliminar dia
- mover dia a otro weekday disponible
- pantalla o modo de organizar semana
- confirmacion si se cambia training a rest con contenido

### Riesgos
- mostrar placeholders de dias inexistentes
- permitir duplicados de weekday
- no liberar weekday al borrar

### Criterio de salida
- el usuario puede construir una semana valida completa
- home responde correctamente a dias vacios, descanso y entrenamiento

## Fase 5 - Sesion Diaria y CRUD de Ejercicios
### Objetivo
Hacer utilizable el flujo principal de entrenamiento real.

### Trabajo
- detalle de dia de entrenamiento
- agregar fuerza
- editar fuerza
- eliminar fuerza
- agregar cardio manual
- editar cardio manual
- eliminar cardio
- crear o abrir WorkoutSession por fecha
- guardar series hechas, reps y peso real
- checks por serie
- indicador de ultimo peso usado

### Congelado para cardio manual V1
- tipo de cardio
- duracion en minutos
- inclinacion opcional

### No hacer aun
- importacion automatica de cardio
- campos avanzados manuales que agreguen friccion

### Criterio de salida
- se puede completar una sesion diaria real de principio a fin
- los datos guardados distinguen plantilla de ejecucion real

## Fase 6 - Reordenar, Mover, Copiar y Conflictos
### Objetivo
Completar el CRUD funcional al 100 por ciento.

### Trabajo
- reordenar ejercicios en un dia
- mover ejercicio a otro dia
- copiar ejercicio a otro dia
- mantener orden estable tras copiar o mover
- confirmar conflictos y perdidas de datos
- introducir UX de dragging y drop target donde corresponda

### Casos que deben quedar resueltos
- copiar a un dia con ejercicios ya existentes
- mover a un dia distinto sin romper historial previo
- reducir series cuando existen logs
- eliminar contenido sin dejar dead ends

### Criterio de salida
- no queda accion principal de CRUD sin flujo funcional

## Fase 7 - Historial, Progreso y Ultimo Peso Usado
### Objetivo
Construir la capa de valor del producto: seguimiento real.

### Trabajo
- construir consultas historicas por ejercicio
- calcular ultimo peso usado
- construir graficas de fuerza
- construir graficas de cardio con estados vacios
- filtros de rango basicos
- resumenes para home o progreso

### Reglas criticas
- ultimo peso usado sale de registros reales, no del template
- graficas usan datos validos y consistentes por fecha
- si no hay historial, mostrar empty state claro y accionable

### Criterio de salida
- el usuario puede ver progreso real y entenderlo rapido

## Fase 8 - Ajustes, Tema y Backup
### Objetivo
Cerrar configuracion global y seguridad local de datos.

### Trabajo
- pantalla de ajustes
- cambiar themeMode system, light, dark
- persistir ajustes
- pantalla de respaldo
- exportar backup local
- importar backup local
- validar schemaVersion del archivo
- confirmar reemplazo de datos locales antes de importar

### Alcance recomendado del backup inicial
- WeeklyPlan
- PlanDay
- ExerciseTemplate
- WorkoutSession
- StrengthSetLog
- CardioLog
- AppSettings

### Criterio de salida
- el usuario puede mover su data local entre estados de la app sin corrupcion evidente

## Fase 9 - Tablet, Microinteracciones y Refinamiento UX
### Objetivo
Llevar la app de funcional a pulida.

### Trabajo
- implementar breakpoints y layouts tablet
- home tablet con dos paneles
- detail tablet con inspector lateral
- progreso tablet con charts paralelos
- animaciones pressed
- estados dragging y drop target reales
- mejorar transiciones de sheets y dialogs
- revisar espaciado, centrado, truncado y legibilidad

### Criterio de salida
- la app se siente nativa y estable en telefono y tablet
- no hay layouts rotos ni adaptaciones improvisadas

## Fase 10 - QA Total, Endurecimiento y Release Prep
### Objetivo
Quitar deuda funcional antes de publicar o entregar build estable.

### Trabajo
- pruebas unitarias clave
- pruebas de widgets esenciales
- pruebas de integracion criticas
- testeo manual de edge cases
- validacion de rendimiento con datos reales
- validar persistencia tras reinicios
- revisar backup import/export con archivos reales
- revisar empty states y conflictos
- preparar icono, nombre final y Android release config

### Checklist de edge cases obligatorios
- no hay dia para hoy
- semana vacia
- weekday duplicado
- cambio a descanso con contenido existente
- reduccion de series con logs previos
- copia o movimiento entre dias
- importacion de backup incompatible
- carga en pantallas pequenas y tablet

### Criterio de salida
- no hay bloqueadores funcionales conocidos
- la app es usable de punta a punta sin datos corruptos

## Orden Real de Ejecucion Recomendado
1. Fase 0
2. Fase 1
3. Fase 2
4. Fase 3
5. Fase 4
6. Fase 5
7. Fase 6
8. Fase 7
9. Fase 8
10. Fase 9
11. Fase 10

No saltar fases salvo para correcciones menores. La unica razon valida para adelantar trabajo visual es si depende de componentes ya cerrados en Fase 3.

## Gates Entre Fases
### Gate A - Antes de UI real
Para pasar de Fase 2 a Fase 3:
- dominio estable
- repositorios funcionando
- sin dudas sobre modelo semanal vs sesion real

### Gate B - Antes de progreso
Para pasar de Fase 6 a Fase 7:
- logs reales guardando bien
- orden, copia y movimiento ya estables
- ultimo peso ya calculable

### Gate C - Antes de backup
Para pasar de Fase 7 a Fase 8:
- schemas estables
- datos consistentes
- consultas historicas verificadas

### Gate D - Antes de cierre
Para pasar de Fase 9 a Fase 10:
- mobile y tablet implementados
- estados vacios y conflictos presentes
- UI sin clips ni desbordes notorios

## Riesgos que Hay que Evitar
- empezar por widgets finales sin dominio estable
- acoplar la UI directo a Isar sin repositorios
- usar el template como si fuera historial
- mezclar progreso con datos planeados en lugar de datos hechos
- dejar backup para el final cuando ya existan schemas inestables
- implementar tablet como simple estiramiento de mobile

## Recomendacion Operativa
La mejor forma de ejecutar esto es trabajar por fase cerrada, no por pantalla aislada.

Ejemplo correcto:
- cerrar Fase 4 completa antes de empezar CRUD de ejercicios

Ejemplo incorrecto:
- hacer Home completa, luego Progress, luego volver al dominio, luego volver a Home

## Entregable Esperado de Este Roadmap
Cuando este roadmap se siga correctamente, el resultado debe ser:
- una base de datos coherente
- una UI consistente con Pencil
- una app funcional offline-first
- progreso confiable
- backup seguro para V1
- soporte real para telefono y tablet
