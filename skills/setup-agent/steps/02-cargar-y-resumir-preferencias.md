# 02 — Cargar y resumir preferencias

## Acción

1. Lee el registro `instructions/preferences/active-preferences.md` para el agente objetivo.
2. Abre cada colección registrada como activa y comprueba que su `applyTo` incluye al agente objetivo.
3. Detecta colecciones que controlen la misma decisión operativa con directrices incompatibles o ambiguas. Conserva esos conflictos para el paso 04.
4. Antes de formular preguntas, presenta un resumen breve: una frase inicial y unas pocas palabras por colección activa.
5. Si no hay colecciones activas, indica de forma concisa que el agente usa solo sus instrucciones base.

## Límite

El resumen describe únicamente lo que ya está activo. No infieras preferencias ausentes ni conviertas una colección compatible pero inactiva en activa.

## Criterio de cierre

El usuario conoce las preferencias activas antes de recibir preguntas, y cada colección activa es compatible con el agente objetivo o está marcada para resolución.
