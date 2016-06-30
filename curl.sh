nova boot --image dc8e5324-c832-4e11-aa1e-464e19f61fac --flavor 1 --nic net-id=617077da-69a0-4872-802f-d047782f84db rally12


67:proj 8de0d61e865d4ee99051b2c94d26e815
99:proj a4fea641aa124d28b7c2fed5d6d854a1
curl -k -X 'POST' -v https://public.fuel.local:5000/v2.0/tokens -H "Content-Type: application/json" -d '{
"auth":{
"passwordCredentials":{
"username": "admin", "password": "admin"}, "tenantId": "a4fea641aa124d28b7c2fed5d6d854a1" }}' |python -m json.tool


curl -k -X 'POST' -v https://10.100.219.67:5000/v2.0/tokens -H "Content-Type: application/json" -d '{                                                                                    
"auth":{
"passwordCredentials":{
"username": "admin", "password": "admin"}, "tenantId": "8de0d61e865d4ee99051b2c94d26e815"}}' |python -m json.tool


curl -k -X 'POST' -v https://10.100.219.15:5000/v2.0/tokens -H "Content-Type: application/json" -d '{                                                                                    
"auth":{
"passwordCredentials":{
"username": "ceilometer", "password": "Yzl0ITmY"}, "tenantId": "a9d83519e87242949e56fca4d6e561e0 "}}' |python -m json.tool

curl -k -X 'POST' -v https://10.100.211.51:5000/v2.0/tokens -H "Content-Type: application/json" -d '{                                                                                    
"auth":{
"passwordCredentials":{
"username": "admin", "password": "111111"}, "tenantId": "2ac4ed87d8f64ed4b083624618179c79"}}' |python -m json.tool




curl -k -X 'POST' -v https://10.100.211.144:5000/v2.0/tokens -H "Content-Type: application/json" -d '{                                                                                    
"auth":{
"passwordCredentials":{
"username": "admin", "password": "admin"}, "tenantId": "bdbafe34e3f34592bfa263337c2f1629"}}' |python -m json.tool



u'https://public.fuel.local:8774/v2/ca209e06e5ea44eeb910f864b281def9'

public.fuel.local
#要加-k 才可以
curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/8de0d61e865d4ee99051b2c94d26e815/flavors |python -m json.tool
curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/admin/flavors |python -m json.tool
curl POST -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/os-floating-ips -H "Content-Type: application/json" -d '{
"pool": "Test_ext"}' |python -m json.tool

curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/flavors |python -m json.tool
1071  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/flavors/details |python -m json.tool
1072  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/flavors/detail |python -m json.tool
1073  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/images |python -m json.tool
1074  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/limits |python -m json.tool
1075  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/servers |python -m json.tool
1076  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/servers/detail |python -m json.tool
1077  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/ips |python -m json.tool
1078  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/servers/ips |python -m json.tool
1079  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/os-floating-ips |python -m json.tool
1080  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/os-floating-ips/b49bb39c-c83b-44da-8c41-39d2a23b8401 |python -m json.tool
1081  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/os-floating-ip-pools |python -m json.tool
1082  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/os-hypervisors |python -m json.tool
1083  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/os-networks |python -m json.tool
1084  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2/a4fea641aa124d28b7c2fed5d6d854a1/os-quota-sets/5b1198be544c434d8d873fac881f5210 |python -m json.tool
1085  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v1/a4fea641aa124d28b7c2fed5d6d854a1/images |python -m json.tool                                                        
1086  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v1/a4fea641aa124d28b7c2fed5d6d854a1/images/details |python -m json.tool
1087  curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v1/a4fea641aa124d28b7c2fed5d6d854a1/images/detail |python -m json.tool
""""""""""""""""""""""""""""""""""""

command line:
create instance
nova boot simth_instance --flavor 3 --image 5e003554-d4c1-48e8-aac0-21d079222a92 --security-groups default --nic net-id=0e189385-1e06-41a8-b690-abd4592e092a 




curl -k -s -H "X-Auth-Token: $TOKEN" https://10.100.219.67:8774/v2.1/a4fea641aa124d28b7c2fed5d6d854a1/servers |python -m json.tool


curl -k -X GET -H "X-Auth-Token:$TOKEN" -H "Content-type: application/json" https://10.100.219.67:9696/v2.0/ports | python -mjson.tool 

curl -X GET -H "X-Auth-Token:d4cc4abcf474448a934fe94f8bb54cac" -H "Content-type: application/json" http://10.100.219.67:35357/v2.0/tenants | python -mjson.tool





https://public.fuel.local:5000
