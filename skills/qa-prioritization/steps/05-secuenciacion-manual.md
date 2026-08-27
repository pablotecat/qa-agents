# Paso 5: Secuenciacion Manual

## Objetivo del Paso

Proponer una secuencia de ejecucion manual factible que respete prerequisitos y mantenga visibles los bloqueos.

## Enfoque Exclusivo

Durante este paso ordena los elementos existentes; no crees pasos de prueba ni supongas estados iniciales.

## Secuencia

1. Lee `references/prioritization-decision-guidance.md` y parte del inventario de prerequisitos.
2. Ordena primero los elementos que crean datos, roles o estados requeridos por otros elementos.
3. Entre elementos desbloqueados, ordena por prioridad `P0`, `P1`, `P2` y `P3`.
4. Para cada posicion, registra prerequisitos satisfechos, bloqueadores restantes y razon del orden.
5. Ante ciclos o prerequisitos ausentes, separa el tramo bloqueado y documenta la accion requerida; no inventes una secuencia.

## Checklist de completitud

- [ ] Cada elemento secuenciado tiene rationale y prerequisitos visibles.
- [ ] La secuencia no viola dependencias conocidas.
- [ ] Los ciclos y bloqueos permanecen fuera de la secuencia ejecutable.