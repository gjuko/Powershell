#This is a script that you can use to find out when a device will come online, by emailing you its name and IP address and the last logged in user,
#so you can better track the machine you're after.
 
#Normally you will run this against a machine always online (server or probe), that you can set to tun every hour/min/secs, etc.
 
#This is the device name the script will be aiming for.
$devicename = Read-Host -Prompt 'Enter the device name'
 
#This command will ping the device passed from the above variable "$devicename" and will capture its network properties
$ipV4 = Test-Connection -ComputerName $devicename -Count 1 -IPv4 | Select-Object -ExpandProperty Address
 
#This will further isolate only the IPv4 address and store it in a variable.
$ipV4.IPAddressToString
 
#This command will try to get the last logged in user on the device that was passed in the $devicename variable and store the info in the $last user variable.                                                      
$lastuser = Get-ChildItem \\$devicename\c$\Users | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime -first 1 | Select-Object Name 
 
#This variable captures the info from the variables $devicename and $lastuser, and presents it in a readable format.
$body = Write-host "Last logged in user to $devicename is $lastuser and the device has the following IP address: $ipV4 | Out-String)"
 
#Here we enter the Send-MailMessage info specific for the device you're running this againts:
$to_address = Read-Host -Prompt 'Please enter an email address for the results to be email to'
$from_address = Read-Host -Prompt 'Please enter the email address, this email will come from'
$SmtpServer = Read-Host -Prompt 'Enter the (email)server to relay this email from'
 
#Now, originally I wanted the $body to run the above, but Send-MailMessage can only parse “get-….. something”, not “write-host” that’s why I’ve reverted to the below:
 
$body = ($ipV4.IPAddressToString,$lastuser)
 
Send-MailMessage -SmtpServer $SmtpServer -To $to_address -From $from_address -Subject "The machine you're waiting is now online" -Body $body 
 