new_window "network"

# top left (0)
run_cmd "sudo nethogs"

# bottom left (2)1
split_h 50
select_pane 0

split_v 50
run_cmd "sudo wavemon"

split_v 50
run_cmd "sudo wavemon"
send_keys "F2"

# top right
select_pane 3
run_cmd "sudo iftop -i wlx00c0ca8fe5b8 -b"
send_keys "t"
split_v 50
run_cmd "sudo bmon -p 'wlx*'"
send_keys "di"

# bottom right
split_v 50
run_cmd "watch -n1 'nmcli d wifi'"

split_h 50
run_cmd "ping 8.8.8.8"
