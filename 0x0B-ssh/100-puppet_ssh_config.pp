# configure ssh client
#$str = "Host * \n \tPasswordAuthentication no \n \tIdentityFile ~/.ssh/school 
#"
#$user = $facts['identity']['user']

#file { '~/.ssh/config':
#    ensure  => present,
#    path    => "/home/${user}/.ssh/config",
#    mode    => '0744',
#    owner   => $user,
#    group   => $user,
#    content => $str,
#}

file_line { 'Turn off passwd auth':
      ensure  => present,
      match   => "^PasswordAuthentication *",
      path    => '/etc/ssh/sshd_conf',
      line    => 'PasswordAuthentication no',
}

file_line { 'Declare identity file':
      ensure  => created,
      match   => "^IdentityFile *",
      path    => '/etc/ssh/sshd_conf',
      line    => 'IdentityFile ~/.ssh/school',
}
