##Powershell Script para descargar desde el SFTP los archivos 
##Creado por Ariel Volpe avolpe@dtvpan.com
##Fecha 14/10/2022

try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "WinSCPnet.dll"
 
    # Setup de conexion
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "sftp-prod-oci.dtvpan.com"
        UserName = "avolpe" #validar si es asi o avolpe@dtvpan.com o dtvpan\avolpe
        Password = "password" #Encriptar el Pass
        SshHostKeyFingerprint = "ssh-rsa 2048 xxxxxxxxxxx..."  #Buscar la LLave del scp y ponerla aqui
    }
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)
 
        # Force binary mode transfer
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
 
        # Download file to the local directory C:\Oracle\Test\Upload
        # Note use of absolute path
        $transferResult =
            $session.GetFiles("/RG_PRD_SAPSMB/sap/interface/in/FCCS/*.txt", "C:\Oracle\Test\Upload\", $False, $transferOptions)
 
        # Throw on any error to emulate the default "option batch abort"
        $transferResult.Check()
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}