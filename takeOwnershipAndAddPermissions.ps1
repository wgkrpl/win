### not tested yet

function Set-OwnerToCurrentUser {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path,

        # Change if you want FullControl, ReadAndExecute, etc.
        [ValidateSet("FullControl","Modify","ReadAndExecute","Read","Write")]
        [string]$Rights = "Modify"
    )

    process {
        $CurrentUser = "$env:USERDOMAIN\$env:USERNAME"

        if (-not (Test-Path $Path)) {
            Write-Warning "Path not found: $Path"
            return
        }

        Write-Host "Taking ownership of $Path"
        takeown /F "$Path" /R /D Y | Out-Null
        icacls "$Path" /setowner "$CurrentUser" /T /C | Out-Null
        Write-Host "Owner set to $CurrentUser" -ForegroundColor Green

        Write-Host "Granting $Rights permission to $CurrentUser"

        $acl = Get-Acl $Path

        # Enable inheritance (keeps existing inherited rules)
        $acl.SetAccessRuleProtection($false, $true)

        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $CurrentUser,
            $Rights,
            "ContainerInherit,ObjectInherit",
            "None",
            "Allow"
        )

        $acl.SetAccessRule($rule)
        Set-Acl -Path $Path -AclObject $acl

        Write-Host "Permissions updated successfully" -ForegroundColor Green
    }
}
