# configure ssh client
$str = "Host *
  PasswordAuthentication no
  IdentityFile ~/.ssh/school 
"

file { '~/.ssh/config':
    ensure  => present,
    path    => '~/.ssh/config',
    mode    => '0744',
    owner   => 'ubuntu',
    group   => 'ubuntu',
    content => $str,
}
