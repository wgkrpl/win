function Set-OwnerToCurrentUser {
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path
    )
    process {
        Write-Host "Taking ownership of $Path"
        takeown /F "$Path" /R /D Y | Out-Null
        icacls "$Path" /setowner "$env:USERDOMAIN\$env:USERNAME" /T | Out-Null
        Write-Host "Owner set to $env:USERDOMAIN\$env:USERNAME" -ForegroundColor Green
    }
}

### usage
### in pwsh console started as admin
### paste the above code
### then run
# Set-OwnerToCurrentUser "C:\WGARWOL\HE\Integrations\OneIB\ADO\Repos\OneIB"
