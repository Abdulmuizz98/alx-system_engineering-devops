# configure ssh client

include stdlib

# install nginx
package { 'Install nginx':
  ensure   => installed,
  name     => 'nginx',
  provider => 'apt',

}

# start nginx service
service { 'start nginx service':
  ensure   => running,
  enable   => 'true',
  provider => 'service',
}
 
# ensure listening on port 80
file_line { 'Listen on port 80 ipv4':
  notify  => Service['start nginx service'],
  ensure  => present,
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tlisten\ [[:digit:]]\+\ ',
  line    => '\tlisten 80 ',
  replace => true,
}

file_line { 'Listen on port 80 ipv6':
  notify  => Service['start nginx service'],
  ensure  => present,
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tlisten\ \[::\]:[[:digit:]]\+\ ',
  line    => '\tlisten [::]:80 ',
  replace => true,
}

# configure redirect of /redirect_me page
file_line { 'Redirect /redirect_me page':
  notify  => Service['start nginx service'],
  ensure  => present,
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tlocation\ /\ {',
  line    => '\tlocation / {\n\t\trewrite ^/redirect_me(.*)$ https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;\n',
  replace => true,
}

# configure custom 404 not found page

$user = $facts['identity']['user']

file { 'Create custom_404.html'
  notify  => Service['start nginx service'],
  ensure  => present,
  path    => '/usr/share/nginx/html/custom_404.html',
  mode    => '0744',
  owner   => $user,
  group   => $uer,
  content => "Ceci n'est pas une page.\n",
}

file_line { 'Configure custom 404 page':
  ensure  => present,
  notify  => Service['start nginx service'],
  path    => '/etc/nginx/sites-enabled/default',
  match   => '^\tserver_name\ _;',
  line    => '\tserver_name _;\n\terror_page 404 /custom_404.html;\n\tlocation = /custom_404.html {\n\t\troot /usr/share/nginx/html;\n\t\tinternal;\n\t}',
  replace => true,
}
