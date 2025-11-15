#!/bin/bash

# =================================================
# SCRIPT DE VALIDAÇÃO - OTIMIZAÇÃO SCORTRIO
# =================================================
# Valida se a otimização foi aplicada corretamente
# Uso: bash validate-optimization.sh
# =================================================

echo "🔍 VALIDANDO OTIMIZAÇÃO DO TEMA SCORTRIO..."
echo "=========================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
PASS=0
FAIL=0
WARN=0

# Arquivo a verificar
FUNCTIONS_FILE="wp-content/themes/scortrio/functions.php"

if [ ! -f "$FUNCTIONS_FILE" ]; then
    echo -e "${RED}❌ Arquivo functions.php não encontrado!${NC}"
    exit 1
fi

echo "📄 Arquivo encontrado: $FUNCTIONS_FILE"
echo ""

# =================================================
# 1. VERIFICAR SE DUPLICATAS FORAM REMOVIDAS
# =================================================

echo "1️⃣ Verificando remoção de código duplicado..."

# Função defer_scripts duplicada?
COUNT=$(grep -c "function scortrio_defer_scripts" "$FUNCTIONS_FILE")
if [ "$COUNT" -eq 1 ]; then
    echo -e "${GREEN}✅ scortrio_defer_scripts: OK (1 definição)${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ scortrio_defer_scripts: DUPLICADA ($COUNT definições)${NC}"
    ((FAIL++))
fi

# Função remove_wp_bloat duplicada?
COUNT=$(grep -c "function scortrio_remove.*bloat" "$FUNCTIONS_FILE")
if [ "$COUNT" -eq 1 ]; then
    echo -e "${GREEN}✅ scortrio_remove_bloat: OK (1 definição)${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ scortrio_remove_bloat: DUPLICADA ($COUNT definições)${NC}"
    ((FAIL++))
fi

# Função optimize_google_fonts duplicada?
COUNT=$(grep -c "function scortrio_optimize.*fonts" "$FUNCTIONS_FILE")
if [ "$COUNT" -le 1 ]; then
    echo -e "${GREEN}✅ Google Fonts: OK${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ Google Fonts: DUPLICADO ($COUNT definições)${NC}"
    ((FAIL++))
fi

# Função remove_jquery_migrate duplicada?
COUNT=$(grep -c "function scortrio_remove_jquery_migrate" "$FUNCTIONS_FILE")
if [ "$COUNT" -eq 1 ]; then
    echo -e "${GREEN}✅ scortrio_remove_jquery_migrate: OK (1 definição)${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ scortrio_remove_jquery_migrate: DUPLICADA ($COUNT definições)${NC}"
    ((FAIL++))
fi

echo ""

# =================================================
# 2. VERIFICAR OTIMIZAÇÕES DE PERFORMANCE
# =================================================

echo "2️⃣ Verificando otimizações de performance..."

# Preconnect para Google Fonts?
if grep -q "preconnect.*fonts.googleapis.com" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Preconnect Google Fonts: OK${NC}"
    ((PASS++))
else
    echo -e "${YELLOW}⚠️  Preconnect Google Fonts: NÃO ENCONTRADO${NC}"
    ((WARN++))
fi

# Display=swap no Google Fonts?
if grep -q "display=swap" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Display swap: OK${NC}"
    ((PASS++))
else
    echo -e "${YELLOW}⚠️  Display swap: NÃO ENCONTRADO${NC}"
    ((WARN++))
fi

# Lazy loading otimizado (LCP)?
if grep -q "fetchpriority.*high" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Fetch priority high (LCP): OK${NC}"
    ((PASS++))
else
    echo -e "${YELLOW}⚠️  Fetch priority: NÃO ENCONTRADO${NC}"
    ((WARN++))
fi

# WebP suporte?
if grep -q "image/webp" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ WebP suporte: OK${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ WebP suporte: NÃO ENCONTRADO${NC}"
    ((FAIL++))
fi

echo ""

# =================================================
# 3. VERIFICAR SEO
# =================================================

echo "3️⃣ Verificando configurações SEO..."

# Filtros Rank Math?
if grep -q "rank_math/frontend/title" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Rank Math title filter: OK${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ Rank Math title filter: NÃO ENCONTRADO${NC}"
    ((FAIL++))
fi

# Schema.org?
if grep -q "schema.org" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Schema.org: OK${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ Schema.org: NÃO ENCONTRADO${NC}"
    ((FAIL++))
fi

# Meta Keywords?
if grep -q "_meta_keywords" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Meta Keywords: OK${NC}"
    ((PASS++))
else
    echo -e "${YELLOW}⚠️  Meta Keywords: NÃO ENCONTRADO${NC}"
    ((WARN++))
fi

echo ""

# =================================================
# 4. VERIFICAR FUNCIONALIDADES ESSENCIAIS
# =================================================

echo "4️⃣ Verificando funcionalidades essenciais..."

# CPT Acompanhantes?
if grep -q "register_post_type.*acompanhante" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ CPT Acompanhantes: OK${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ CPT Acompanhantes: NÃO ENCONTRADO${NC}"
    ((FAIL++))
fi

# Taxonomias?
if grep -q "register_taxonomy.*localizacao" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Taxonomia Localização: OK${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ Taxonomia Localização: NÃO ENCONTRADO${NC}"
    ((FAIL++))
fi

# AJAX Load More?
if grep -q "scortrio_load_more_posts" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ AJAX Load More: OK${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ AJAX Load More: NÃO ENCONTRADO${NC}"
    ((FAIL++))
fi

# Sistema de Favoritos?
if grep -q "scortrio_favorite" "$FUNCTIONS_FILE"; then
    echo -e "${GREEN}✅ Sistema de Favoritos: OK${NC}"
    ((PASS++))
else
    echo -e "${YELLOW}⚠️  Sistema de Favoritos: NÃO ENCONTRADO${NC}"
    ((WARN++))
fi

echo ""

# =================================================
# 5. ESTATÍSTICAS DO ARQUIVO
# =================================================

echo "5️⃣ Estatísticas do arquivo..."

LINES=$(wc -l < "$FUNCTIONS_FILE")
FUNCTIONS=$(grep -c "^function " "$FUNCTIONS_FILE")
HOOKS=$(grep -c "add_action\|add_filter" "$FUNCTIONS_FILE")

echo "📊 Linhas de código: $LINES"
echo "📊 Funções definidas: $FUNCTIONS"
echo "📊 Hooks registrados: $HOOKS"
echo ""

# Validar tamanho
if [ "$LINES" -lt 2800 ]; then
    echo -e "${GREEN}✅ Tamanho otimizado (< 2800 linhas)${NC}"
    ((PASS++))
elif [ "$LINES" -lt 3000 ]; then
    echo -e "${YELLOW}⚠️  Tamanho OK mas pode melhorar ($LINES linhas)${NC}"
    ((WARN++))
else
    echo -e "${RED}❌ Arquivo ainda muito grande ($LINES linhas)${NC}"
    ((FAIL++))
fi

echo ""

# =================================================
# RESUMO FINAL
# =================================================

echo "=========================================="
echo "📊 RESUMO DA VALIDAÇÃO"
echo "=========================================="
echo ""
echo -e "${GREEN}✅ Passou: $PASS testes${NC}"
echo -e "${YELLOW}⚠️  Avisos: $WARN testes${NC}"
echo -e "${RED}❌ Falhou: $FAIL testes${NC}"
echo ""

TOTAL=$((PASS + WARN + FAIL))
SCORE=$((PASS * 100 / TOTAL))

echo "🎯 Score: $SCORE%"
echo ""

if [ "$FAIL" -eq 0 ] && [ "$WARN" -eq 0 ]; then
    echo -e "${GREEN}🎉 PERFEITO! Otimização aplicada corretamente!${NC}"
    exit 0
elif [ "$FAIL" -eq 0 ]; then
    echo -e "${YELLOW}✅ BOM! Otimização aplicada com alguns avisos.${NC}"
    echo "Consulte MIGRATION_GUIDE.md para completar."
    exit 0
else
    echo -e "${RED}⚠️  ATENÇÃO! Existem problemas a corrigir.${NC}"
    echo "Consulte MIGRATION_GUIDE.md para instruções."
    exit 1
fi
