# create a manifest that kills a process named killmenow.

$pname = 'killmenow'
exec { "kill_process_${pname}":
    command  => "pkill ${pname}",
    provider => shell,
}
