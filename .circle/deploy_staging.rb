#!/usr/bin/env ruby

ENV['AWS_DEFAULT_REGION'] = 'ap-northeast-1'

ip_addr = `curl -s icanhazip.com`
if ! ip_addr
  ip_addr = `curl -s ifconfig.me`
end
ip_addr = ip_addr.chomp
security_group = 'sg-026cd767'

code =<<EOF
set -ex

trap "aws ec2 revoke-security-group-ingress --group-id #{security_group} --protocol tcp --port 22 --cidr #{ip_addr}/32" 0 1 2 3 15
aws ec2 authorize-security-group-ingress --group-id #{security_group} --protocol tcp --port 22 --cidr #{ip_addr}/32
bundle exec cap staging deploy
EOF
`#{code}`

if $? != 0
  raise :some_exception
end
