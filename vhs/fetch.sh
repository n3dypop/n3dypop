
#!/usr/bin/env bash
# Source this script to make the static `fetch` command available.

fetch() {
  local dir logo line label value detail
  local i detail_index

  dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  logo="$dir/ascii-art.txt"

  if [[ ! -f "$logo" ]]; then
    printf 'Missing ASCII art: %s\n' "$logo" >&2
    return 1
  fi

  # Layout configuration
  local right_offset=3
  local label_column=50
  local value_column=70

  local -a details=(
    'n3dypop@github|'
    '────────────────────────────────────|'
    ''
    '  Focus|TUI Applications'
    ''
    '  Languages|Rust · C++ · Go · Python'
    ''
    ' |Java · Ruby · JavaScript · Swift'
    ''
    '󰟀  Platforms|Windows · macOS · Arch Linux'
    ''
    '  Tools|JetBrains IDEs · Zed · Codex · Obsidian'
    ''
    '󰊤  GitHub|github.com/n3dypop'
    ''
    ''
    '● ● ● ● ● ●|'
  )

  local -a logo_lines=()
  mapfile -t logo_lines < "$logo"

  for ((i = 0; i < ${#logo_lines[@]}; i++)); do
    logo_lines[i]="${logo_lines[i]%$'\r'}"
  done

  local logo_height=${#logo_lines[@]}
  local detail_height=${#details[@]}
  local required_height=$((right_offset + detail_height))
  local total_height=$logo_height

  if ((required_height > total_height)); then
    total_height=$required_height
  fi

  # Get terminal dimensions.
  local terminal_rows terminal_cols
  terminal_rows="$(tput lines 2>/dev/null)" || terminal_rows=0
  terminal_cols="$(tput cols 2>/dev/null)" || terminal_cols=0

  # Prevent accidental line wrapping.
  if ((terminal_cols > 0 && value_column >= terminal_cols)); then
    printf 'Terminal is too narrow: %s columns\n' \
      "$terminal_cols" >&2
    return 1
  fi

  # Center vertically only when the content fits.
  local top_padding=0

  if ((terminal_rows > total_height)); then
    top_padding=$(((terminal_rows - total_height) / 2))
  fi

  # Clear screen and position cursor.
  printf '\033[2J\033[H'

  # Print leading blank lines.
  for ((i = 0; i < top_padding; i++)); do
    printf '\n'
  done

  # Render profile.
  for ((i = 0; i < total_height; i++)); do
    line="${logo_lines[i]:-}"

    if [[ -n "$line" ]]; then
      printf '  \033[1;35m%s\033[0m' "$line"
    fi

    detail_index=$((i - right_offset))

    if ((detail_index >= 0 && detail_index < detail_height)); then
      detail="${details[detail_index]}"

      if [[ -n "$detail" ]]; then
        if [[ "$detail" == '● ● ● ● ● ●|' ]]; then
          printf '\033[%dG' "$label_column"
          printf '\033[35m● \033[34m● \033[36m● '
          printf '\033[32m● \033[33m● \033[31m●\033[0m'
        else
          label="${detail%%|*}"
          value="${detail#*|}"

          if [[ "$label" == 'n3dypop@github' ]]; then
            printf '\033[%dG\033[1;36m%s\033[0m' \
              "$label_column" "$label"
          elif [[ "$label" == '────────────────────────────────────' ]]; then
            printf '\033[%dG\033[90m%s\033[0m' \
              "$label_column" "$label"
          else
            if [[ -n "${label// /}" ]]; then
              printf '\033[%dG\033[1;36m%s\033[0m' \
                "$label_column" "$label"
            fi

            if [[ -n "$value" ]]; then
              printf '\033[%dG\033[37m%s\033[0m' \
                "$value_column" "$value"
            fi
          fi
        fi
      fi
    fi

    # Do not advance beyond the last rendered row.
    if ((i < total_height - 1)); then
      printf '\n'
    fi
  done

  # Reset cursor position for the next shell prompt.
  printf '\r\n'
}
