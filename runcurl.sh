#uploadinit
curl -k -u admin:infoblox -H 'content-type:application/json' -X POST "https://gridmaster/wapi/v2.11/fileop?_function=uploadinit"


#csv_import
#curl -k1 -u admin:infoblox -X POST 'https://192.168.60.25/wapi/v2.11.2/fileop?_function=csv_import' -d '{"operation":"UPDATE","action":"START","on_error":"CONTINUE","update_method":"OVERRIDE","token":"eJytjk8LgjAchr+K7JzObW2aN8OCICqizkPcsh+os7mgiL57jqhjp67P+/eB9K0He5cOWo2ygAga\nJ2lKSRIxLghLJwG62mZU0Nm5fsgwJjMaEZFGIo4ox55KBVZXTp6g0RIMtvoiQYXH3XqbF2HMCY0J\nFzxhnE2ZwND2xr7daKxXpSul7iqjoKv90Hy1+fLWKH8LFfkhl/vF8iN4hgdnbFlr7Nr+Dz9A+dLf\nGfR8AYwDWrU=\n"}'
