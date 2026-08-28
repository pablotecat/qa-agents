#!/usr/bin/env node
// qa-agents — Descarga el runtime de agentes QA desde GitHub y lo copia a .agents/.
// El runtime NO va dentro del paquete npm: se descarga con shallow clone para obtener siempre
// la última versión del repo pablotecat/qa-agent-creation. Overwrite forzado idempotente.
// Sin dependencias npm externas; requiere `git` instalado. Node >= 16.7 (fs.cpSync).

import { existsSync, cpSync, statSync, readdirSync, rmSync } from "node:fs";
import { execSync } from "node:child_process";
import { tmpdir } from "node:os";
import { resolve, join, relative, basename } from "node:path";

// Repo fuente del runtime (debe ser público para clonar sin auth).
const SOURCE_REPO = "https://github.com/pablotecat/qa-agent-creation.git";
const DEFAULT_BRANCH = "main";

// Directorios runtime del repo que se copian al destino/.agents/.
const RUNTIME_DIRS = ["agents", "instructions", "prompts", "scripts", "skills"];

// Destino: <cwd>/.agents/  (cwd del usuario que ejecuta npx)
const destRoot = resolve(process.cwd(), ".agents");

function fail(message) {
  console.error(`✖ ${message}`);
  process.exit(1);
}

function parseArgs(argv) {
  const branch = DEFAULT_BRANCH;
  for (let i = 2; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === "--branch" || arg === "-b") {
      const next = argv[i + 1];
      if (!next) fail(`Flag --branch requiere un valor (ej. --branch main)`);
      return { branch: next };
    }
    if (arg === "--help" || arg === "-h") {
      console.log(`Uso: npx qa-agents [--branch <rama>]

Descarga el runtime QA (agentes, instrucciones, prompts, skills) desde
${SOURCE_REPO} (rama "${DEFAULT_BRANCH}" por defecto) y lo copia a ./.agents/.

Opciones:
  --branch, -b <rama>   Rama alternativa a clonar (default: ${DEFAULT_BRANCH})
  --help, -h            Muestra esta ayuda
`);
      process.exit(0);
    }
    fail(`Argumento no reconocido: ${arg}. Usa --help para ver las opciones.`);
  }
  return { branch };
}

function hasGit() {
  try {
    execSync("git --version", { stdio: "ignore" });
    return true;
  } catch {
    return false;
  }
}

function shallowClone(repoUrl, branch, targetDir) {
  // git clone --depth 1 --branch <branch> <url> <dir>
  // stdio pipe para no volcar el progreso de git en la salida del bin.
  execSync(
    `git clone --depth 1 --branch ${branch} ${repoUrl} ${JSON.stringify(targetDir)}`,
    { stdio: "pipe" }
  );
}

function countFiles(entryPath, shouldCount = () => true) {
  // Cuenta archivos (no directorios) de forma recursiva; ignora errores de lectura.
  // Respeta el filtro `shouldCount(src)` para excluir archivos (ej. vestigiales 'old.*').
  let count = 0;
  const stack = [entryPath];
  while (stack.length > 0) {
    const cur = stack.pop();
    if (!shouldCount(cur)) continue;
    let stat;
    try {
      stat = statSync(cur);
    } catch {
      continue;
    }
    if (stat.isFile()) {
      count += 1;
    } else if (stat.isDirectory()) {
      try {
        const entries = readdirSync(cur, { withFileTypes: true });
        for (const e of entries) stack.push(join(cur, e.name));
      } catch {
        // ignore unreadable dir
      }
    }
  }
  return count;
}

function main() {
  const { branch } = parseArgs(process.argv);

  console.log(
    `qa-agents — instalando runtime QA en .agents/\n` +
      `  fuente: ${SOURCE_REPO}\n` +
      `  rama:   ${branch}\n`
  );

  if (!hasGit()) {
    fail(
      `No se encontró 'git' en el PATH. Instala Git (https://git-scm.com) y reintenta.`
    );
  }

  // Shallow clone a un directorio temporal único.
  const tmpCloneDir = join(
    tmpdir(),
    `qa-agents-clone-${process.pid}-${Date.now()}`
  );
  // Limpieza garantizada incluso si falla algo a mitad de camino.
  const cleanup = () => {
    try {
      rmSync(tmpCloneDir, { recursive: true, force: true });
    } catch {
      // best-effort
    }
  };

  console.log(`  ↓ clonando repo...`);
  try {
    shallowClone(SOURCE_REPO, branch, tmpCloneDir);
  } catch (err) {
    cleanup();
    const stderr = err.stderr ? err.stderr.toString().trim() : err.message;
    fail(
      `No se pudo clonar ${SOURCE_REPO} (rama ${branch}).\n` +
        `  ${stderr}\n` +
        `  Verifica que el repo exista, sea público y la rama sea correcta.`
    );
  }

  // Validar que al menos una carpeta runtime existe en el clone.
  const available = RUNTIME_DIRS.filter((d) => {
    const p = join(tmpCloneDir, d);
    return existsSync(p) && statSync(p).isDirectory();
  });

  if (available.length === 0) {
    cleanup();
    fail(
      `No se encontraron carpetas runtime (${RUNTIME_DIRS.join(", ")}) en el repo clonado.\n` +
        `  Quizás la rama "${branch}" no contiene el runtime esperado.`
    );
  }

  // Overwrite forzado idempotente: force:true + recursive:true.
  // Excluir archivos marcados como vestigiales (prefijo 'old.') para no propagarlos a destinos.
  const isNotVestigial = (src) => {
    const base = basename(src);
    return !base.startsWith("old.");
  };

  let totalFiles = 0;
  let copiedDirs = 0;

  for (const dir of available) {
    const src = join(tmpCloneDir, dir);
    const dst = join(destRoot, dir);
    try {
      cpSync(src, dst, {
        recursive: true,
        force: true,
        errorOnExist: false,
        preserveTimestamps: true,
        filter: (s) => isNotVestigial(s),
      });
      copiedDirs += 1;
      const files = countFiles(src, isNotVestigial);
      totalFiles += files;
      console.log(
        `  ✓ ${dir.padEnd(14)} → ${relative(process.cwd(), dst)}  (${files} ${files === 1 ? "archivo" : "archivos"})`
      );
    } catch (err) {
      cleanup();
      fail(`Error copiando '${dir}': ${err.message}`);
    }
  }

  cleanup();

  console.log(
    `\n✔ ${totalFiles} ${totalFiles === 1 ? "archivo copiado" : "archivos copiados"} en ${copiedDirs} ${copiedDirs === 1 ? "carpeta" : "carpetas"} → ${relative(process.cwd(), destRoot) || ".agents"}`
  );
  console.log(
    `\nLos agentes QA están disponibles en .agents/. Ya puedes invocarlos desde GitHub Copilot.`
  );
}

main();
