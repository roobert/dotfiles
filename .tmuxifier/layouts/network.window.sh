new_window "network"

# pane 0
run_cmd "sudo nethogs"

# pane 1
split_v 50
run_cmd "sudo wavemon"

# pane 2
select_pane 0
split_h 50
run_cmd "sudo iftop -i wlx00c0ca8fe5b8 -b"
send_keys "t"

# pane 3
select_pane 2
split_h 50
run_cmd "watch -n1 'nmcli d wifi'"

split_h 50
run_cmd "ping 8.8.8.8"
