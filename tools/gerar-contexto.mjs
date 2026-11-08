#!/usr/bin/env node
// Gera docs/CONTEXTO_IA.md e docs/contexto.json a partir de main.lua + src/**/*.lua.
// Uso: node tools/gerar-contexto.mjs (a partir de qualquer diretório).
// Os propósitos curados por arquivo ficam em tools/descricoes-modulos.json.

import { readdir, readFile, writeFile, mkdir } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

const RAIZ = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

// Base raw do GitHub: detectada via git remote/branch, com fallback fixo do projeto.
const RAW_FALLBACK = 'https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/';

function git(args) {
  try {
    return execFileSync('git', args, { cwd: RAIZ, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } catch {
    return '';
  }
}

function detectarRawBase() {
  const remote = git(['remote', 'get-url', 'origin']);
  const branch = git(['rev-parse', '--abbrev-ref', 'HEAD']) || 'main';
  const m = remote.match(/github\.com[/:]([^/]+)\/([^/]+?)(?:\.git)?$/);
  if (m) return `https://raw.githubusercontent.com/${m[1]}/${m[2]}/refs/heads/${branch}/`;
  return RAW_FALLBACK;
}

const RAW_BASE = detectarRawBase();

async function listarLua(dir) {
  const entradas = await readdir(dir, { withFileTypes: true });
  const arquivos = [];
  for (const entrada of entradas) {
    const completo = path.join(dir, entrada.name);
    if (entrada.isDirectory()) arquivos.push(...(await listarLua(completo)));
    else if (entrada.name.endsWith('.lua')) arquivos.push(completo);
  }
  return arquivos;
}

function paraCaminhoRelativo(absoluto) {
  return path.relative(RAIZ, absoluto).split(path.sep).join('/');
}

function extrairCabecalho(linhas) {
  const cabecalho = [];
  let emBloco = false;
  for (const linha of linhas) {
    const t = linha.trim();
    if (emBloco) {
      cabecalho.push(t);
      if (t.includes('--]]')) emBloco = false;
      continue;
    }
    if (t === '') {
      if (cabecalho.length > 0) break;
      continue;
    }
    if (t.startsWith('--[[')) {
      cabecalho.push(t);
      emBloco = !t.includes('--]]');
      continue;
    }
    if (t.startsWith('--!')) continue;
    if (t.startsWith('--')) {
      cabecalho.push(t);
      continue;
    }
    break;
  }
  return cabecalho.join('\n');
}

function assinaturaAteParenteses(texto) {
  const inicio = texto.indexOf('(');
  if (inicio === -1) return texto;
  let nivel = 0;
  for (let i = inicio; i < texto.length; i++) {
    if (texto[i] === '(') nivel++;
    else if (texto[i] === ')') {
      nivel--;
      if (nivel === 0) return texto.slice(0, i + 1);
    }
  }
  return texto;
}

function extrairFuncoes(linhas) {
  const funcoes = [];
  linhas.forEach((linha, indice) => {
    const t = linha.trim();
    let m = t.match(/^(local\s+)?function\s+([A-Za-z_][\w.:]*)\s*\(/);
    if (m) {
      funcoes.push({ linha: indice + 1, local: Boolean(m[1]), assinatura: assinaturaAteParenteses(t) });
      return;
    }
    m = t.match(/^([A-Za-z_][\w.]*)\s*=\s*function\s*\(/);
    if (m) funcoes.push({ linha: indice + 1, local: false, assinatura: assinaturaAteParenteses(t) });
  });
  return funcoes;
}

function extrairRegistros(linhas) {
  const registros = [];
  linhas.forEach((linha, indice) => {
    const m = linha.match(/^([A-Za-z_][\w.]*)\s*=\s*\{/);
    if (m) registros.push({ linha: indice + 1, nome: m[1] });
  });
  return registros;
}

function extrairRetorno(linhas) {
  for (let i = linhas.length - 1; i >= 0; i--) {
    const m = linhas[i].match(/^return\s+([A-Za-z_]\w*)/);
    if (m) return m[1];
  }
  return null;
}

async function main() {
  const alvos = [path.join(RAIZ, 'main.lua'), ...(await listarLua(path.join(RAIZ, 'src')))];
  alvos.sort((a, b) => paraCaminhoRelativo(a).localeCompare(paraCaminhoRelativo(b)));

  let descricoes = {};
  try {
    descricoes = JSON.parse(await readFile(path.join(RAIZ, 'tools', 'descricoes-modulos.json'), 'utf8'));
  } catch {
    console.warn('Aviso: tools/descricoes-modulos.json não encontrado; usando apenas cabeçalhos.');
  }

  const arquivos = [];
  for (const alvo of alvos) {
    const caminho = paraCaminhoRelativo(alvo);
    const conteudo = await readFile(alvo, 'utf8');
    const linhas = conteudo.split(/\r?\n/);
    arquivos.push({
      caminho,
      rawUrl: RAW_BASE + caminho,
      bytes: Buffer.byteLength(conteudo, 'utf8'),
      linhas: linhas.length,
      proposito: descricoes[caminho] ?? null,
      cabecalho: extrairCabecalho(linhas),
      funcoes: extrairFuncoes(linhas),
      registros: extrairRegistros(linhas),
      retorno: extrairRetorno(linhas),
    });
  }

  const geradoEm = new Date().toISOString();
  const dirDocs = path.join(RAIZ, 'docs');
  await mkdir(dirDocs, { recursive: true });

  const json = { geradoEm, rawBase: RAW_BASE, totalArquivos: arquivos.length, arquivos };
  await writeFile(path.join(dirDocs, 'contexto.json'), JSON.stringify(json, null, 2) + '\n', 'utf8');

  const md = [];
  md.push('# Contexto do repositório para IA');
  md.push('');
  md.push(`> Gerado automaticamente por \`tools/gerar-contexto.mjs\` em ${geradoEm}.`);
  md.push('> Não edite manualmente: altere `tools/descricoes-modulos.json` e rode `node tools/gerar-contexto.mjs`.');
  md.push('');
  md.push(`Total: **${arquivos.length} scripts Lua**. Versão machine-readable: \`docs/contexto.json\`.`);
  md.push('');
  md.push('Para entender um módulo em profundidade, leia o arquivo fonte indicado em cada seção.');
  md.push('');
  md.push('## Leitura via raw do GitHub');
  md.push('');
  md.push('Cada script tem uma URL raw para leitura direta por IA/agentes (sem clonar o repositório).');
  md.push(`Base: \`${RAW_BASE}\` — some o caminho relativo do arquivo para obter o conteúdo integral.`);
  md.push('');
  md.push('Lista completa (caminho -> URL raw):');
  md.push('');
  for (const arq of arquivos) {
    md.push(`- \`${arq.caminho}\` -> ${arq.rawUrl}`);
  }
  md.push('');
  md.push('---');
  md.push('');
  for (const arq of arquivos) {
    md.push(`## \`${arq.caminho}\``);
    md.push('');
    md.push(`**Raw:** ${arq.rawUrl}`);
    md.push('');
    md.push(`${arq.linhas} linhas · ${arq.bytes} bytes${arq.retorno ? ` · retorna \`${arq.retorno}\`` : ''}`);
    md.push('');
    if (arq.proposito) {
      md.push(`**Propósito:** ${arq.proposito}`);
      md.push('');
    }
    if (arq.cabecalho) {
      md.push('Cabeçalho do arquivo:');
      md.push('');
      md.push('```lua');
      md.push(arq.cabecalho);
      md.push('```');
      md.push('');
    }
    if (arq.funcoes.length > 0) {
      md.push('Funções:');
      md.push('');
      for (const f of arq.funcoes) {
        md.push(`- \`${f.assinatura}\` (linha ${f.linha}${f.local ? ', local' : ''})`);
      }
      md.push('');
    }
    if (arq.registros.length > 0) {
      md.push('Tabelas/registros de topo:');
      md.push('');
      for (const r of arq.registros) md.push(`- \`${r.nome}\` (linha ${r.linha})`);
      md.push('');
    }
    if (!arq.proposito && !arq.cabecalho && arq.funcoes.length === 0) {
      md.push('_Arquivo vazio ou sem conteúdo documentável._');
      md.push('');
    }
  }
  await writeFile(path.join(dirDocs, 'CONTEXTO_IA.md'), md.join('\n'), 'utf8');

  const semDescricao = arquivos.filter((a) => !a.proposito).map((a) => a.caminho);
  console.log(`${arquivos.length} scripts indexados -> docs/CONTEXTO_IA.md e docs/contexto.json`);
  console.log(`Base raw: ${RAW_BASE}`);
  if (semDescricao.length > 0) {
    console.log(`Sem descrição curada (${semDescricao.length}): ${semDescricao.join(', ')}`);
  }
}

main().catch((erro) => {
  console.error(erro);
  process.exit(1);
});