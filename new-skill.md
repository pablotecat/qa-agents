# Implementación de la skill `setup-agent`

## Objetivo

Diseñar e implementar una nueva skill denominada **`setup-agent`** cuyo propósito sea:

> **Permitir que el usuario adapte el comportamiento operativo del agente sin modificar manualmente sus prompts.**

La implementación debe priorizar un **MVP funcional**, evitando sobreingeniería y dejando preparadas las bases para futuras iteraciones.

---

# Primera fase: planificación

Antes de modificar ningún archivo, analiza el proyecto y genera un plan de implementación.

El plan debe incluir, como mínimo:

* Archivos que será necesario crear.
* Archivos que deberán modificarse.
* Dependencias con otras skills o componentes.
* Riesgos o posibles conflictos.
* Orden recomendado de implementación.
* Posibles mejoras futuras (sin implementarlas).

No implementes funcionalidades que no formen parte del MVP únicamente porque puedan resultar útiles en el futuro.

---

# Funcionamiento esperado

Cuando el usuario invoque la skill `setup-agent`, el agente deberá:

1. Analizar:

   * sus instrucciones globales;
   * sus instrucciones específicas del rol;
   * las preferencias existentes (si las hubiera).

2. Identificar qué decisiones de comportamiento requieren criterios del usuario para adaptarse mejor a sus expectativas.

No debe intentar detectar errores en sí mismo.

Debe detectar únicamente aspectos de comportamiento configurables.

---

# Preferencias

Las preferencias constituyen una nueva capa de instrucciones.

La organización esperada es similar a:

```text
Instructions/
    Global/
    Agent/
    Preferences/
```

Las preferencias:

* forman parte de las instrucciones del agente;
* no son memoria;
* no modifican el prompt original;
* simplemente complementan las instrucciones existentes.

Las preferencias deberán almacenarse como archivos Markdown utilizando el mismo estilo que el resto de instrucciones del proyecto.

No es necesario estructurarlas mediante YAML, JSON u otros formatos.

El texto libre en Markdown es suficiente.

---

# Tipos de preguntas

El agente podrá utilizar dos tipos de preguntas.

## Preguntas fijas

Definidas por el proyecto.

Aplican a todos los agentes o a un rol determinado.

## Preguntas dinámicas

El propio agente podrá generar nuevas preguntas cuando detecte que existe una decisión relevante de comportamiento que todavía no está cubierta por las preferencias existentes.

Estas preguntas deben estar justificadas por el rol del agente.

No deben ser aleatorias.

En futuras iteraciones podrán convertirse en preguntas fijas, pero esa funcionalidad no forma parte del MVP.

---

# Regla para formular preguntas

El agente únicamente formulará una pregunta cuando la respuesta pueda modificar de forma material su comportamiento operativo.

Si la respuesta no cambia ninguna decisión relevante del agente, la pregunta no debe hacerse.

No existe un límite fijo de preguntas.

La calidad y relevancia son más importantes que la cantidad.

---

# Resumen inicial

Antes de formular preguntas, el agente mostrará un breve resumen de las preferencias actualmente activas utilizando únicamente unas pocas palabras por preferencia.

El objetivo es que el usuario conozca el modo de funcionamiento actual antes de responder.

---

# Confirmación implícita

Las respuestas del usuario durante la conversación constituyen la confirmación de los cambios.

No es necesario mostrar una pantalla adicional de confirmación antes de escribir las preferencias.

---

# Resolución de conflictos

Si el agente detecta preferencias incompatibles o ambiguas:

* nunca debe decidir automáticamente;
* deberá preguntar al usuario.

La resolución automática de conflictos no forma parte del MVP.

---

# Persistencia

Las preferencias podrán almacenarse con distintos ámbitos:

* Proyecto
* Usuario
* Sesión
* Bajo demanda

La implementación debe respetar esta organización aunque inicialmente algunos ámbitos compartan comportamiento interno.

---

# Historial

Cada modificación de preferencias deberá registrarse en un historial.

El objetivo es poder conocer cómo han evolucionado las preferencias del agente a lo largo del tiempo.

No es necesario implementar funcionalidades avanzadas sobre este historial.

Basta con mantener un registro cronológico.

---

# Restricciones

No modificar directamente:

* instrucciones globales;
* instrucciones específicas del agente.

La skill únicamente deberá crear o modificar archivos de preferencias y su historial correspondiente.

---

# Filosofía del diseño

Mantener la implementación sencilla.

Evitar introducir complejidad innecesaria.

Priorizar un MVP fácilmente mantenible y extensible.

Las futuras mejoras (detección automática de desajustes, aprendizaje a partir del uso, generación automática de nuevas preguntas fijas, etc.) deberán documentarse como posibles evoluciones, pero no implementarse en esta primera versión.

---

# Resultado esperado

Al finalizar la planificación, presentar:

1. Arquitectura propuesta.
2. Plan de implementación paso a paso.
3. Lista de archivos a crear o modificar.
4. Riesgos detectados.
5. Orden recomendado de desarrollo.

Una vez aprobado el plan, comenzar la implementación siguiendo dicho orden y manteniendo cambios pequeños, revisables y coherentes con la arquitectura existente del proyecto.
