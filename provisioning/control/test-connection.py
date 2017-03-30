import winrm

s = winrm.Session('192.168.50.4', auth=('vagrant', 'vagrant'))
r = s.run_cmd('ipconfig', ['/all'])

print("Status Code is: "+str(r.status_code))

print("Result is: "+str(r.std_out))