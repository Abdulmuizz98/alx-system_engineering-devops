# configure a new nginx server, redirects and error page.

include stdlib

# update and install nginx

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}

package { 'Install nginx':
  ensure  => installed,
  name    => 'nginx',
  require => Exec['apt-get update'],

}

# start nginx service
service { 'start nginx service':
  ensure  => running,
  #enable   => 'true',
  require => Package['Install nginx'],
  start   => 'service nginx start',
  restart => 'service nginx restart',
  status  => 'service nginx status',
  stop    => 'service nginx stop',

  #iprovider => 'service',
}

# create index page with string hello world!
file { 'Create index.html':
  ensure  => present,
  notify  => Service['start nginx service'],
  path    => '/var/www/html/index.html',
  mode    => '0744',
  owner   => $user,
  group   => $uer,
  content => 'Hello World!\n',
}

# ensure listening on port 80
file_line { 'Listen on port 80 ipv4':
  ensure  => present,
  notify  => Service['start nginx service'],
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tlisten\ [[:digit:]]\+\ default_server;',
  line    => "\tlisten 80 default_server;",
  replace => true,
}

file_line { 'Listen on port 80 ipv6':
  ensure  => present,
  notify  => Service['start nginx service'],
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tlisten\ \[::\]:[[:digit:]]\+\ default_server;',
  line    => "\tlisten [::]:80 default_server;",
  replace => true,
}

# configure redirect of /redirect_me page
file_line { 'Redirect /redirect_me page':
  ensure  => present,
  notify  => Service['start nginx service'],
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tlocation\ /\ {',
  line    => "\tlocation / {\n\t\trewrite ^/redirect_me(.*)$ https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;\n",
  replace => true,
}

# configure custom 404 not found page

$user = $facts['identity']['user']

file { 'Create custom_404.html':
  ensure  => present,
  notify  => Service['start nginx service'],
  path    => '/usr/share/nginx/html/custom_404.html',
  mode    => '0744',
  owner   => $user,
  group   => $uer,
  content => "Ceci n'est pas une page.\n\n",
}

file_line { 'Configure custom 404 page':
  ensure  => present,
  notify  => Service['start nginx service'],
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tserver_name\ _;',
  line    => "\tserver_name _;\n\terror_page 404 /custom_404.html;\n\tlocation = \
/custom_404.html {\n\t\troot /usr/share/nginx/html;\n\t\tinternal;\n\t}",
  replace => true,
}
