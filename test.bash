#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Haruto Nakanou
# SPDX-License-Identifier: BSD-3-Clause

set -euo pipefail

actual=$(printf '名前,年齢,出身地\n太郎,20,東京\n花子,,大阪\n空白,   ,名古屋\n次郎,21\n三郎,18,札幌,備考\n' | ./csv-row-check | tr -d '\r')
expected=$(printf '3,2,年齢,不足\n4,2,年齢,不足\n5,3,出身地,不足\n6,4,,余分')

if [[ "$actual" != "$expected" ]]; then
    printf '出力が期待と異なります\n期待値:\n%s\n実際:\n%s\n' "$expected" "$actual" >&2
    exit 1
fi

actual=$(printf '名前,年齢\n太郎,20\n' | ./csv-row-check | tr -d '\r')
if [[ -n "$actual" ]]; then
    printf '問題のないCSVなのに出力がありました: %s\n' "$actual" >&2
    exit 1
fi

if ./csv-row-check </dev/null >/dev/null 2>/dev/null; then
    printf 'ヘッダーのない入力を受け入れました\n' >&2
    exit 1
fi

printf 'OK\n'
