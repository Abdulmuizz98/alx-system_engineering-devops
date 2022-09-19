# configure ssh client
$str = "Host * \n \tPasswordAuthentication no \n \tIdentityFile ~/.ssh/school 
"
$user = $facts['identity']['user']

file { '~/.ssh/config':
    ensure  => present,
    path    => "/home/${user}/.ssh/config",
    mode    => '0744',
    owner   => $user,
    group   => $user,
    content => $str,
}
