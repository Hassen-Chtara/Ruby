#!/usr/bin/ruby
require "ipaddress"

input=ARGV[0].chomp

if input.include? '/'
   ip = input[0,(input.index '/')]
   mask = input[(input.index '/')+1,input.length].to_i
else
  puts "The input must be with this format IP/MASK . \n exemple :127.0.0.1/8"
  exit
end

if !IPAddress.valid? ip 
  puts "Invalid IP address"
  exit
end


def to_binary(n,l=8)
  b=n.to_s(2)
  return "0" * (l-b.length) + b
end
b_mask= '1'*mask+'0'*(32-mask)
b_ip=""
ip.split(".").each do |i|
  b_ip << to_binary(i.to_i)
end
def to_ip(s)
  return s.split(/([0-1]{8})/)[1].to_i(2).to_s+"."+s.split(/([0-1]{8})/)[3].to_i(2).to_s+"."+s.split(/([0-1]{8})/)[5].to_i(2).to_s+"."+s.split(/([0-1]{8})/)[7].to_i(2).to_s
end

def binary_not(s)
  ret=''
  s.split('').each do |i| 
    ret << (i=='1' ? '0' : '1')
  end
  return ret
end

b_network= to_binary(b_mask.to_i(2) & b_ip.to_i(2),32)
b_broadcast=to_binary(binary_not(b_mask).to_i(2) | b_ip.to_i(2),32)
b_first_ip = b_network[0,b_network.length-1]+'1'
b_last_ip = b_broadcast[0,b_broadcast.length-1]+'0'

puts "Calculating the IP range of #{input}"

puts "=========================================="

puts "IP  #{to_ip(b_ip)}"

puts "Netmask  #{to_ip(b_mask)}"

puts "Network ID  #{ to_ip(b_network) }"

puts "Broadcast address  #{ to_ip(b_broadcast) }"

puts "Host range  #{to_ip(b_first_ip)} - #{to_ip(b_last_ip)}"

puts "Max number of hosts  #{ b_broadcast.to_i(2)-b_network.to_i(2) -2}"

