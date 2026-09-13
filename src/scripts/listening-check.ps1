$service = Get-Service TermService
$port = Get-NetTCPConnection -LocalPort 3389 -State Listen -ErrorAction SilentlyContinue

if ($service.Status -eq "Running" -and $port) {
    exit 0   # RDP OK
}
else {
    exit 1   # RDP NOT OK
}