function fish_command_not_found
  paplay "/home/mikku/.local/share/fahhh/fahhh.mp3" >/dev/null 2>&1 &
  echo "fish: unknown command: $argv[1]" >&2
end
