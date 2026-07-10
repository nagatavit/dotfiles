#!/bin/bash
# Claude Code status line
# Order: [dir] model | ctx% ctx-bar | 5h-reset 5h% 5h-bar | 7d-reset 7d% 7d-bar

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
case "$cwd" in
  "$HOME"*) dir_display="~${cwd#$HOME}" ;;
  *) dir_display="$cwd" ;;
esac

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

RESET="\033[0m"
WHITE="\033[97m"
CYAN="\033[96m"
MAGENTA="\033[95m"
GREEN="\033[92m"
YELLOW="\033[93m"
WEEK="\033[38;5;208m"

make_bar() {
  local pct="$1" width=10
  local ipct=${pct%.*}
  [ -z "$ipct" ] && ipct=0
  [ "$ipct" -gt 100 ] && ipct=100
  [ "$ipct" -lt 0 ] && ipct=0
  # round to whole cells (full blocks only — no fractional gaps)
  local filled=$(( (ipct * width + 50) / 100 ))
  local bar="" i
  for ((i = 0; i < filled; i++)); do bar="${bar}█"; done
  for ((i = filled; i < width; i++)); do bar="${bar}░"; done
  printf '%s' "$bar"
}

fmt_time() {
  local epoch="$1"
  [ -z "$epoch" ] && return
  date -d "@$epoch" "+%H:%M" 2>/dev/null
}

fmt_datetime() {
  local epoch="$1"
  [ -z "$epoch" ] && return
  date -d "@$epoch" "+%a %H:%M" 2>/dev/null
}

out=""

# [dir] — brackets white, path cyan
out+=$(printf "${WHITE}[${RESET}${CYAN}%s${WHITE}]${RESET}" "$dir_display")
out+=" "
out+=$(printf "${MAGENTA}%s${RESET}" "$model")

# context: percentage, then bar
if [ -n "$used_pct" ]; then
  bar=$(make_bar "$used_pct")
  out+=" "
  out+=$(printf "${GREEN}%.0f%% [%s]${RESET}" "$used_pct" "$bar")
fi

# 5h session: reset time, percentage, bar
if [ -n "$five_pct" ]; then
  reset_time=$(fmt_time "$five_reset")
  bar=$(make_bar "$five_pct")
  out+=" "
  if [ -n "$reset_time" ]; then
    out+=$(printf "${YELLOW}%s %.0f%% [%s]${RESET}" "$reset_time" "$five_pct" "$bar")
  else
    out+=$(printf "${YELLOW}%.0f%% [%s]${RESET}" "$five_pct" "$bar")
  fi
fi

# 7d weekly: reset datetime, percentage, bar
if [ -n "$week_pct" ]; then
  reset_dt=$(fmt_datetime "$week_reset")
  bar=$(make_bar "$week_pct")
  out+=" "
  if [ -n "$reset_dt" ]; then
    out+=$(printf "${WEEK}%s %.0f%% [%s]${RESET}" "$reset_dt" "$week_pct" "$bar")
  else
    out+=$(printf "${WEEK}%.0f%% [%s]${RESET}" "$week_pct" "$bar")
  fi
fi

printf '%b\n' "$out"
