#!/bin/bash
# Claude Code status line:
#   model · mode · dir  branch · ctx % · $cost · 5h % ↻ reset · 7d % ↻ reset
# Uses the terminal's ANSI colors (follows Ghostty's Catppuccin light/dark).
# Plan usage (rate_limits) is only sent for claude.ai Pro/Max logins.

input=$(cat)

IFS=$'\x1f' read -r model effort fast style dir cost ctx h5 h5_reset d7 d7_reset < <(
  jq -r '[
    .model.display_name, .effort.level, .fast_mode, .output_style.name,
    .workspace.current_dir, .cost.total_cost_usd, .context_window.used_percentage,
    .rate_limits.five_hour.used_percentage, .rate_limits.five_hour.resets_at,
    .rate_limits.seven_day.used_percentage, .rate_limits.seven_day.resets_at
  ] | map(. // "" | tostring) | join("\u001f")' <<<"$input"
)

dim=$'\033[2m' reset=$'\033[0m'
sep=" ${dim}·${reset} "

# Green < 50%, yellow < 80%, red otherwise
pct() {
  local p
  p=$(printf '%.0f' "$1")
  local color=$'\033[32m'
  ((p >= 50)) && color=$'\033[33m'
  ((p >= 80)) && color=$'\033[31m'
  printf '%s%s%%%s' "$color" "$p" "$reset"
}

out="$model"

mode="$effort"
[[ "$fast" == true ]] && mode="${mode:+$mode }⚡fast"
[[ -n "$style" && "$style" != default ]] && mode="${mode:+$mode }($style)"
[[ -n "$mode" ]] && out+="${sep}${mode}"

if [[ -n "$dir" ]]; then
  out+="${sep}\033[34m${dir##*/}${reset}"
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && out+=" \033[35m ${branch}${reset}"
fi

[[ -n "$ctx" ]] && out+="${sep}ctx $(pct "$ctx")"
[[ -n "$cost" ]] && out+="${sep}$(printf '$%.2f' "$cost")"

if [[ -n "$h5" ]]; then
  out+="${sep}5h $(pct "$h5")"
  [[ -n "$h5_reset" ]] && out+=" ${dim}↻ $(date -r "$h5_reset" '+%H:%M')${reset}"
fi
if [[ -n "$d7" ]]; then
  out+="${sep}7d $(pct "$d7")"
  [[ -n "$d7_reset" ]] && out+=" ${dim}↻ $(date -r "$d7_reset" '+%a %H:%M')${reset}"
fi

printf '%b\n' "$out"
