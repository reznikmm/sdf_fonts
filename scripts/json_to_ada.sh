#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# json_to_ada.sh — Convert msdf-atlas-gen JSON glyph data to Ada case aggregates.
#
# Usage: ./json_to_ada.sh [input.json]

set -euo pipefail

INPUT="${1:-aaa.json}"

jq -r '
  .glyphs | to_entries[] |
  .key as $i |
  .value as $g |
  (
    if ($g | has("planeBounds")) then
      "         when \($i) =>\n        (\($g.advance),\n         (\($g.planeBounds.left), \($g.planeBounds.right), \($g.planeBounds.top), \($g.planeBounds.bottom)),\n         (\($g.atlasBounds.left), \($g.atlasBounds.right), \($g.atlasBounds.top), \($g.atlasBounds.bottom))),"
    else
      "         when \($i) =>\n        (\($g.advance),\n         (0.0, 0.0, 0.0, 0.0),\n         (0.0, 0.0, 0.0, 0.0)),"
    end
  )
' "$INPUT"
