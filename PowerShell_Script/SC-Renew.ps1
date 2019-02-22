#######################################################################
# NAME: SC-Renew.ps1
# 
# DESCRIPTION: To allow CSS Supplier renewal of annual 2FA Smart Card Certificates over open internet
# 
# Support: Please contact your VIS PM if you encounter any issues
#
# Authors: Mayank Bansal 
# (C) Copyright 2016 MICROSOFT
#
# This code and information are provided "as is" without warranty of any kind, either expressed or implied, 
# including but not limited to the implied warranties of merchantability and/or fitness for a particular purpose.
#
# HISTORY
# 1.0 - 01-Sep-16 - Initial release 
# 2.0 - 05-Sep-18 - Updated public URLs and added function to remove old enrollment policy server
########################################################################


[CmdletBinding()]
param (
    $CEPURL = 'https://co1-ndes-05.microsoft.com/ADPolicyProvider_CEP_Certificate/service.svc/CEP',
    $CES = 'https://co1-ndes-05.microsoft.com/Microsoft%20Intranet%20Level%202%20User%20CA%203_CES_Certificate/service.svc/CES',
    $CEPID ='{CAEF6331-EECA-11D2-A5D8-00805F9F21F540}',
    $TMPL
)

$OldCEPURL = 'https://co1-ndes-05.glbdns2.microsoft.com/ADPolicyProvider_CEP_Certificate/service.svc/CEP' 
# ALERTING: Turn on/off the types of alerting that are wanted.
# OFF=0, ON=1
$EVENT_LOG_ALERT_ON=0
$CONSOLE_ALERT_ON=1
$FILE_LOG_ALERT_ON=1

#String used as the Source in event log events 
$EVENT_SOURCE= "XXX"

#Alert Levels 
$INFO_ALERT = 6
$ERROR_ALERT = 2
$WARNING_ALERT = 1
$NO_ALERT = 0

#Event IDs 
$EVENT_SCRIPT_START=40
$EVENT_SCRIPT_STOP=41
$EVENT_EXCEPTION=42
$EVENT_CERTCOUNT=43
$EVENT_CMD=44
$EVENT_CEP_ADD=45
$EVENT_CEP_Remove=46
$Event = 10

#COM Constant

$CONTEXT_USER = 1
$AUTH_CERTIFICATE =8 
$PsfLocationRegistry  = 2  


#INF file. This file will be used to change extended properties of the certificate and stamp CEP server URL in property ID 87
$file = @"
[Version]
Signature = "`$Windows NT$"

[Strings]
CERT_CEP_PROP_ID=87

[Properties]
%CERT_CEP_PROP_ID% = "{text}"
_continue_="URL=$CEPURL&"
_continue_="ID=$CEPID&"
_continue_="Authority=$CES&"
_continue_="RequestId=163&"
_continue_="Flags=0&"             ; EnrollmentPolicyServerPropertyFlags
_continue_="Authentication=$AUTH_CERTIFICATE&"    ; X509EnrollmentAuthFlags
_continue_="UrlFlags=32&"          ; PolicyServerUrlFlags
_continue_="AuthorityAuthentication=$AUTH_CERTIFICATE&" ; X509EnrollmentAuthFlags
"@

#Microsoft  Internal SHA2 Root Certificate in Base64 Format
$RCertB64 = @"
MIIFsDCCA5igAwIBAgIQCx8BEem5Cp1K2NZtNZ9wADANBgkqhkiG9w0BAQsFADAs
MSowKAYDVQQDEyFNaWNyb3NvZnQgSW50ZXJuYWwgQ29ycG9yYXRlIFJvb3QwHhcN
MTIwNDA1MjE1NDU0WhcNMzcwNDA1MjIwMTA1WjAsMSowKAYDVQQDEyFNaWNyb3Nv
ZnQgSW50ZXJuYWwgQ29ycG9yYXRlIFJvb3QwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQCV2ldlrpoImQLgnSMRmPCan4PHEw+Gxd2JecDmnas8ZF1VMj5M
7qhKnahwIJCoasPjnYORprpbkUZrAMM+yp3aQ+Ob7qn2d1EVxRduozSnQ1siu5DS
tXGIPv1z19h2wJ2T6uZEde59Vy3tyBfekYkaq9+d4Zh+ie+j6mvaufPG0Job7FZs
G9B2KfjggLXiT5OnOqGgB/ODk+OtWJQyUCXyCUHgUwg8d+ZhHTZqfKZL5E6riz7f
tgo707/EiySCJe8L4uXJSOqfCBgrzQyOik0Uh811DFmGPF0pT42RWUZGLSmAGxuM
pSRZcCkvuhfeSczeR/hwCQiiLcoM1c6apoFtipq7B0NhpL29SE9KyGFQ0BwlH+HI
U+/ccOZotaO70nte5CuIDCxS3aM8MnhWhCKGdG3UUbw5nQIQOrV7mid31TAmex8p
omuqpVfGfnlNJ23orvyWMhbOKC6Gxf+vIiYHf75ZPsW/0+eKGRRh3u/ZwSIzG+CK
XxeFO4BngLbkmmVgJDQMHk9KaOfT/Z3gX3G/hpNoOVCds8/eWSFn4XVje8Db+8r0
LWPycxAQyT54d9sXBtWkSKLlfKfnntghz04TTmhz6xSt7H1S/Wi2FwmgCX9l3HxU
9xAIF5gORk/tQjLgpFx+dj7d5NC+aQA44s1K2YoMOQl1Yd42X6wPsdHk0wIDAQAB
o4HNMIHKMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTb
7ApkqM7ADumIVA7pyN7EeEt6YTAQBgkrBgEEAYI3FQEEAwIBADB5BgNVHSAEcjBw
MG4GBFUdIAAwZjBkBggrBgEFBQcCAjBYHlYAaAB0AHQAcAA6AC8ALwB3AHcAdwAu
AG0AaQBjAHIAbwBzAG8AZgB0AC4AYwBvAG0ALwBwAGsAaQAvAG0AcwBjAG8AcgBw
AC8AYwBwAHMALgBoAHQAbTANBgkqhkiG9w0BAQsFAAOCAgEANIbFeirCqX6EPqeX
qG85j5m9RVfQ/Oklc9WyduELqndZM+IveFHPLw8pVlShCx0s20xnis/EjQvDKB2X
8Ht1X6FzqO1hEAnDFR5GLPA63iMMmyNim3HlihSj258MMMOqxD9pGrpcvFA0oTlF
5wBcq+9G2n7q7jqcuX/zToReRKiyxSZumZrFhcAjcQNjd/4o8uTCdx8Xzy61qJ+j
JlHW4GSEw8VIFhwiilUxTX7qj+T2ovgYR13S8cqfS5GxUL0onU4EO02P6+pODDb4
YWKOc2/K8889QSrq4sh399a4kQjpmQbO8E/bkgyvecxCGIXmRQwONG7AS8JAAUa6
FONYFh8T6+73xQvl7jTDDZ28mejldK4pcnR/DLosq6vCDvEMRQfOC60UVVRgGzBE
5KrrGxtciYb+MTFhQdqbg8YWBErIo/x69pAPFv1iOSjHGyhCKXAhhyCl3XtxhSce
wqPP7OdhWK8KjvhCpGr9OfBB3aNceTer/hg6XAEaYs46xUBiZzJ3hYltp701Pqkl
hauFJdMA1RnR5ZcNm9k2lCT6tUH1nAXa1/NNwzHIbcAIoLL3zM/TKxPD5HGhMl9F
ioZFbWgnVH0v7c0rMqeIKLqq8psMfiv4rCs40XT4L8+HHo837L4Il2Wlp21Zqcae
fmYdme6j2jHNaIDICL++IJjnzbI=
"@

function ErrorHandle($ex) {
    #####################################
    # Name: ErrorHandle
    # Purpose: To send the error details to AlertID function
    # Inputs: Exception object
    # Returns: None
    #####################################   
    $StrError =  "CAUGHT AN EXCEPTION: " + $_.Exception.ToString() 
    AlertID $StrError $ERROR_ALERT $EVENT_EXCEPTION $EVENT_SOURCE
}

function AlertID($strAlert, $intSeverity, $intEventID, $strEventSource) {
    #####################################
    # Name: AlertID
    # Purpose: Sends alerts according to configuration
    # Inputs: The alert text string, integer severity, integer eventID and integer event source for event logging
    # Returns: None
    #####################################
    
    switch($intSeverity) {
            $ERROR_ALERT     { $strError="ERROR"; $strErrorType="Error: " }
            $WARNING_ALERT   { $strError="WARNING"; $strErrorType="Warning: " }
            $INFO_ALERT      { $strError="INFORMATION"; $strErrorType="Information: "}
            $NO_ALERT        { return }
    }
        
    if($CONSOLE_ALERT_ON) {
        Write-Host "======================================"
        Write-Host "EventID:  $intEventID"
        Write-Host "Source:   $strEventSource"
        Write-Host "Severity: $intSeverity"
        Write-Host ""
        Write-Host "Details: $strErrorType $strAlert"
        Write-Host "======================================"
    }
    if($EVENT_LOG_ALERT_ON) {
        try {
            Write-Verbose("Writing alert to the event log...")
            Write-EventLog -logname "Application" -source $strEventSource -eventID $intEventID -entrytype $strError -message ($strErrorType + $strAlert)
        }
        catch { ErrorHandle $_.Exception }
    }

        if($FILE_LOG_ALERT_ON) {
        Add-Content -Path "$env:temp\PSCRenewal-$Date.txt" -value "$strErrorType $strAlert"
    }


}


function AddPolicyServer() {
    #####################################
    # Name: AddPolicyServer
    # Purpose: Adds the enrollment policy server to current users certificate store
    # Inputs: None
    # Returns: None
    #####################################
    Try{
        AlertID "Adding CEP Server...." $INFO_ALERT $EVENT_CEP_ADD $EVENT_SOURCE
        $PolURL = New-Object -ComObject X509Enrollment.CX509PolicyServerUrl.1 #IX509PolicyServerUrl
        $PolURL.Initialize($CONTEXT_USER)
        $POlURL.SetStringProperty(0,$CEPID)
        $PolURL.Url = $CEPURL
        $PolURL.AuthFlags = $AUTH_CERTIFICATE #Set certificate authentication
        $PolURL.Flags = $PsfLocationRegistry
        $PolURL.UpdateRegistry($CONTEXT_USER) #update URL to local user's registry location
        AlertID "CEP Server Added Successfully...." $INFO_ALERT $EVENT_CEP_ADD $EVENT_SOURCE
       }
    Catch{ErrorHandle $_.Exception}

}

function RemovePolicyServer() {
    #####################################
    # Name: RemovePolicyServer
    # Purpose: Remove old enrollment policy server from current users certificate store
    # Inputs: None
    # Returns: None
    #####################################
        AlertID "Removing Old CEP Server...." $INFO_ALERT $EVENT_CEP_Remove $EVENT_SOURCE
        $PolURL = New-Object -ComObject X509Enrollment.CX509PolicyServerUrl.1 #IX509PolicyServerUrl
        $PolURL.Initialize($CONTEXT_USER)
        $PolURL.Url = $OldCEPURL
        Try { 
            $PolURL.RemoveFromRegistry($CONTEXT_USER)
            AlertID "Old CEP Server Removed Successfully...." $INFO_ALERT $EVENT_CEP_Remove $EVENT_SOURCE
        } Catch {AlertID "Old CEP Server not found..." $INFO_ALERT $EVENT_CEP_Remove $EVENT_SOURCE}
        
}

Function CreateLogFile {
    #####################################
    # Name: CreateLogFile
    # Purpose: Creates log file in $env:temp folder to capture script flow
    # Inputs: None
    # Returns: None
    #####################################
    Try{
        set-content "$env:temp\PSCRenewal-$Date.txt" -Value $null
        if (test-path -Path "$env:temp\PSCRenewal-$Date.txt") {AlertID "Log File Created Successfully...." $INFO_ALERT $EVENT $EVENT_SOURCE}
        Else {AlertID "Log File Creation Failed...." $ERROR_ALERT $EVENT $EVENT_SOURCE}
    }
    Catch{ErrorHandle $_.Exception}

}


Function Install-Rootcert {
    Try{
        $store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::Root,"CurrentUser")
        $store.Open('readwrite')
        $RCertObj = [System.Security.Cryptography.X509Certificates.X509Certificate2]([System.Convert]::FromBase64String($RCertB64))
        $store.Add($RCertObj)
        $RootCert = $store.Certificates | where {$_.subject -eq "CN=Microsoft Internal Corporate Root"}
        if($RootCert) {$StrError = "Root Certificate Imported Sucessfully";AlertID $StrError $INFO_ALERT $EVENT $EVENT_SOURCE}
        Else{$StrError = "Root Certificate Import Failed";AlertID $StrError $ERROR_ALERT $EVENT $EVENT_SOURCE}
    }
    catch{ErrorHandle $_.Exception}
}



#############################################
# Start main program
#############################################

$Date = Get-Date -Format MMddyyhhmm   #

if ($FILE_LOG_ALERT_ON) { CreateLogFile} #Create log file

AlertID "Starting PSC Renewal Tool..." $INFO_ALERT $EVENT_SCRIPT_START $EVENT_SOURCE

RemovePolicyServer #Calling function to remove older enrollment policy server from current users certificate store

AddPolicyServer #Calling function to add enrollment policy server to current users certificate store

Install-Rootcert #Installing Microsoft Internal Corporate Root to user trusted root store

try{

    $file | set-content $env:temp\inf.txt
    $store=new-object System.Security.Cryptography.X509Certificates.X509Store
    $store.open("ReadOnly") # Open current user certificate store to list all the certificates
    
    #If no certificate found in user store, create warning event otherwise count the number of certs
    if ($store.Certificates.Count -eq 0) { 
        AlertID "No Certitificate Found In User Store" $WARNING_ALERT $EVENT_TOTALCERT $EVENT_SOURCE }
    Else{ AlertID "Total # of Certificates in User Store: $($store.Certificates.Count)" $Info_ALERT $EVENT_CERTCOUNT $EVENT_SOURCE }


    # Add all physical smartcard certs to $certs object
    # If user supply template OID find that one otherwise find certificate based on following template
    # "MS Smartcard User"
    # "MSIT SHA2 Smartcard"
    # "MSIT Smartcard"
    if ($TMPL) { $certs = $store.certificates | where { $_.Extensions|  where { $_.format(0) -match $TMPL} } }
    Else {
        $Certs = $Store.Certificates |
        where { $_.Extensions |
            where  {       
                ( $_.Format(0) -match '1.3.6.1.4.1.311.21.8.7587021.751874.11030412.6202749.3702260.207.272170.15046368' ) -or ` # "MSIT Smartcard"
                ( $_.Format(0) -match '1.3.6.1.4.1.311.21.8.7587021.751874.11030412.6202749.3702260.207.12234172.8497063' )         -or ` # "MSIT SHA2 Smartcard"
                ( $_.Format(0) -match '1.3.6.1.4.1.311.21.8.7587021.751874.11030412.6202749.3702260.207.2004006270.2008951254' ) # "MS Smartcard User"
            } 
        }
    
    }

    #If no physical smartcard certificate found in user store, create warning log otherwise display count of PSC certs
    if ($certs.Count -eq 0) { 
        AlertID "No PSC Certitificate Found In User Store" $WARNING_ALERT $EVENT_TOTALCERT $EVENT_SOURCE }
    Else{ AlertID "Total # of PSC Certificates in User Store: $($Certs.Count)" $Info_ALERT $EVENT_CERTCOUNT $EVENT_SOURCE }

    AlertID "Starting Certificate Repair" $INFO_ALERT $Event $EVENT_SOURCE

    Write-host -ForegroundColor Green "============================================================
    This process may take several minutes to complete. Please do not cancel/close this screen. 
    It will automatically close and start Certificate Manager when ready for Smart Card Certificate Renewal.
    ============================================================"


    #Run repair store command on all PSC certs and add CEP policy URL as defined in the inf file
    foreach ($cert in $certs){
        $result = & Certutil.exe -repairstore -user my $($cert.thumbprint) $env:temp\inf.txt
        if ($lastexitcode -ne 0) {
            $strError = "Repair Store Command Failed With Below Error...`n" + $Result
            AlertID $StrError $ERROR_ALERT $EVENT_CMD $EVENT_SOURCE
        } 
        Else {
            $strError = "Repair Store Command Succeeded ...`n" + $Result
            AlertID $StrError $INFO_ALERT $EVENT_CMD $EVENT_SOURCE
        }

    } 
}
catch{ErrorHandle $_.Exception}


#Launching user certificate store mmc to renew certificate

start-process certmgr.msc

AlertID "Exiting PSC Renewal Tool..." $INFO_ALERT $EVENT_SCRIPT_STOP $EVENT_SOURCE

# SIG # Begin signature block
# MIIjjgYJKoZIhvcNAQcCoIIjfzCCI3sCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBPqGGFm8a5ukPM
# yKBQX7XG7xJNA2gCb9fwWGuF4PC8O6CCDYEwggX/MIID56ADAgECAhMzAAABA14l
# HJkfox64AAAAAAEDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTgwNzEyMjAwODQ4WhcNMTkwNzI2MjAwODQ4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDRlHY25oarNv5p+UZ8i4hQy5Bwf7BVqSQdfjnnBZ8PrHuXss5zCvvUmyRcFrU5
# 3Rt+M2wR/Dsm85iqXVNrqsPsE7jS789Xf8xly69NLjKxVitONAeJ/mkhvT5E+94S
# nYW/fHaGfXKxdpth5opkTEbOttU6jHeTd2chnLZaBl5HhvU80QnKDT3NsumhUHjR
# hIjiATwi/K+WCMxdmcDt66VamJL1yEBOanOv3uN0etNfRpe84mcod5mswQ4xFo8A
# DwH+S15UD8rEZT8K46NG2/YsAzoZvmgFFpzmfzS/p4eNZTkmyWPU78XdvSX+/Sj0
# NIZ5rCrVXzCRO+QUauuxygQjAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUR77Ay+GmP/1l1jjyA123r3f3QP8w
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDM3OTY1MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAn/XJ
# Uw0/DSbsokTYDdGfY5YGSz8eXMUzo6TDbK8fwAG662XsnjMQD6esW9S9kGEX5zHn
# wya0rPUn00iThoj+EjWRZCLRay07qCwVlCnSN5bmNf8MzsgGFhaeJLHiOfluDnjY
# DBu2KWAndjQkm925l3XLATutghIWIoCJFYS7mFAgsBcmhkmvzn1FFUM0ls+BXBgs
# 1JPyZ6vic8g9o838Mh5gHOmwGzD7LLsHLpaEk0UoVFzNlv2g24HYtjDKQ7HzSMCy
# RhxdXnYqWJ/U7vL0+khMtWGLsIxB6aq4nZD0/2pCD7k+6Q7slPyNgLt44yOneFuy
# bR/5WcF9ttE5yXnggxxgCto9sNHtNr9FB+kbNm7lPTsFA6fUpyUSj+Z2oxOzRVpD
# MYLa2ISuubAfdfX2HX1RETcn6LU1hHH3V6qu+olxyZjSnlpkdr6Mw30VapHxFPTy
# 2TUxuNty+rR1yIibar+YRcdmstf/zpKQdeTr5obSyBvbJ8BblW9Jb1hdaSreU0v4
# 6Mp79mwV+QMZDxGFqk+av6pX3WDG9XEg9FGomsrp0es0Rz11+iLsVT9qGTlrEOla
# P470I3gwsvKmOMs1jaqYWSRAuDpnpAdfoP7YO0kT+wzh7Qttg1DO8H8+4NkI6Iwh
# SkHC3uuOW+4Dwx1ubuZUNWZncnwa6lL2IsRyP64wggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVYzCCFV8CAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAQNeJRyZH6MeuAAAAAABAzAN
# BglghkgBZQMEAgEFAKCBtjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgvn/vUv0/
# zRM9PGLcdZgeCfo9KVqlra0RjLKpbW09D4EwSgYKKwYBBAGCNwIBDDE8MDqgGoAY
# AFMAQwAtAFIAZQBuAGUAdwAuAHAAcwAxoRyAGmh0dHBzOi8vd3d3Lm1pY3Jvc29m
# dC5jb20gMA0GCSqGSIb3DQEBAQUABIIBAF0eCVTNiBTYy+nClu+LgEPXJvGxCQMt
# geNln0ghBGNYe0Np3hK+xONvwI8/SSxDc1qHHEcEcYs5j+4LEcrELaAGUN+5oaqi
# x2iDhBILP283CE5rrqa5vyBTSaU8lnVhtR8vg0PcvrIvcwC2KoRJlSk7Rt6njshH
# wRgWOwcRm7PRkdMb+2hny+0c19tWeMc9nPBcDoPJ9vK4VPNBYQyOq8aAu6zD66mp
# dQqMdg+F/LC9yrIYPP1k+8IA9kOkOsEZierjRAKt8kus9+y/XujFXjliRyBY3m9w
# qt81LpPzo+w1f4/37U4DoD9i+tHM/+raXYKrb62fqZotKG+cn8vXXlihghLlMIIS
# 4QYKKwYBBAGCNwMDATGCEtEwghLNBgkqhkiG9w0BBwKgghK+MIISugIBAzEPMA0G
# CWCGSAFlAwQCAQUAMIIBUQYLKoZIhvcNAQkQAQSgggFABIIBPDCCATgCAQEGCisG
# AQQBhFkKAwEwMTANBglghkgBZQMEAgEFAAQgXc6TFzsqzf5OLKwh7lkV8FLnUFBi
# VezIzV68SMmL9zICBluPDT2gERgTMjAxODA5MDcyMTI0MDUuNjg4WjAEgAIB9KCB
# 0KSBzTCByjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAldBMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1p
# Y3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlvbnMgTGltaXRlZDEmMCQGA1UECxMdVGhh
# bGVzIFRTUyBFU046MTc5RS00QkIwLTgyNDYxJTAjBgNVBAMTHE1pY3Jvc29mdCBU
# aW1lLVN0YW1wIHNlcnZpY2Wggg48MIIE8TCCA9mgAwIBAgITMwAAANuqbeMifzQA
# JQAAAAAA2zANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Eg
# MjAxMDAeFw0xODA4MjMyMDI2NTNaFw0xOTExMjMyMDI2NTNaMIHKMQswCQYDVQQG
# EwJVUzELMAkGA1UECBMCV0ExEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQg
# T3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjoxNzlF
# LTRCQjAtODI0NjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgc2Vydmlj
# ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKehmpAMmCSLSzZuzf07
# rE9UXP5TCqLREDDOqiAw3pa5kSYKdRAwnQmvAw4lFA2cTfCLjFL9znS3+J+8CWG2
# iynHEIirVgkDr6nG18H28rvG7djdoROqHWNmY8yzP3YF+kiIv5Rq7gfXYCYsb+0y
# G37xgW6DfSLHBN8oJq0GZ3c75J4SiGViIF/3tolUP2s9I+UpZSGsOR2lRQyxBhTT
# davvriKURstRz3PA//P/rC08j5GpNfzft9Sq5TjKUPkXvT+uRGHordY6sdaxCqLj
# voEYYo2NDKLCXEPC3m8LBSK7WV0CTSwj3AqJNC/sehs2+i3ZF29kczH1itOzJS+q
# TQsCAwEAAaOCARswggEXMB0GA1UdDgQWBBSyut8dgFxzps227eQcjK3eKkMDSDAf
# BgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBH
# hkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNU
# aW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUF
# BzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1RpbVN0
# YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsG
# AQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQAVQsKanb0ZYH4iR4kk6YGV1V5uV2NR
# m/pH7JeTWTFMWGkgFQH9AJkU5E+uEfLgjrdQMq/NycE4QIq0cb0HVnYOKPGnivFD
# hmadZH1aBQWQf/DlviyHGhID9faqntPOAtm51jAGvno7H4xGzd7SzmsvA9hgw9zr
# dsiCtkx1s5uCPcVFdEAFi+oS9NLk2NFC5utPK6JHONLkFNDpBBYsv5Pd1D2DyY1J
# PgShshDRr/UxV4bcM+EHGMKXRmeuwMAdEYk+3a3qMopMRt9sZIrIo3H6w23Q7LRE
# ZqlcuBrMXxT8pOXlUqUfWFi/j3vr8hoP8EJzHJZRrkq/cJk6WlRkPSGLMIIGcTCC
# BFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJv
# b3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzAxMjEzNjU1WhcN
# MjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCASIw
# DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkdDbx3EYo6IOz8E5f1+n9plGt0
# VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMnBDEfQRsalR3OCROOfGEwWbEw
# RA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq9UeBzb8kYDJYYEbyWEeGMoQe
# dGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8RsEnHSRnEnIaIYqvS2SJUGKx
# Xf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v0Ev9buWayrGo8noqCjHw2k4G
# kbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN/LzAyURdXhacAQVPIk0CAwEA
# AaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTVYzpcijGQ80N7
# fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBoAYDVR0g
# AQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYB
# BQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0AGUA
# bQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAAfmiFEN4sbgmD+BcQM9naOh
# IW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4vceoniXj+bzta1RXCCtRgkQS
# +7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3TvQhDIr79/xn/yN31aPxzymXlK
# kVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8z+0DpZaPWSm8tv0E4XCfMkon
# /VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVKC5Em4jnsGUpxY517IW3DnKOi
# PPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhquBEKDuLWAmyI4ILUl5WTs9/S/
# fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF0M2n0O99g/DhO3EJ3110mCII
# YdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+YWtvd6mBy6cJrDm77MbL2IK0
# cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt6o3gMy4SKfXAL1QnIffIrE7a
# KLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0MkvfY3v1mYovG8chr1m1rtxEPJdQ
# cdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgvvM9YBS7vDaBQNdrvCScc1bN+
# NR4Iuto229Nfj950iEkSoYICzjCCAjcCAQEwgfihgdCkgc0wgcoxCzAJBgNVBAYT
# AlVTMQswCQYDVQQIEwJXQTEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFuZCBP
# cGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjE3OUUt
# NEJCMC04MjQ2MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBzZXJ2aWNl
# oiMKAQEwBwYFKw4DAhoDFQBbpSlOrxis+HA8JE9qRFutb8fbMKCBgzCBgKR+MHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBBQUAAgUA3zzX
# cDAiGA8yMDE4MDkwNzE4NTQ0MFoYDzIwMTgwOTA4MTg1NDQwWjB3MD0GCisGAQQB
# hFkKBAExLzAtMAoCBQDfPNdwAgEAMAoCAQACAiq8AgH/MAcCAQACAhGIMAoCBQDf
# PijwAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMH
# oSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQADgYEAbDytv8MK5p5lEYm5jqm7
# 6C6TuIgmaBRw7rKrPDuyKn2cPS+7q2zekNZI7WNKA8wZNsmzCmAQPtcU/xj2jcJN
# urSlpQZeSe6vzfaHBD0OpIHAyR6tijOsnUsPoC0dP4hiRgsdnf3AoO4MY21mZMhK
# w4Xq7mFfaKwiPz85/YrBZgUxggMNMIIDCQIBATCBkzB8MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
# dGFtcCBQQ0EgMjAxMAITMwAAANuqbeMifzQAJQAAAAAA2zANBglghkgBZQMEAgEF
# AKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEi
# BCAlAmEU/8cGlxu+ht2aW+ycqCCCyy1XtELbjMEKUuz/cDCB+gYLKoZIhvcNAQkQ
# Ai8xgeowgecwgeQwgb0EIAJTHbHTmAEtIrVqIyVjsIt9R7biILf8sPry650hjP6q
# MIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEm
# MCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAADbqm3j
# In80ACUAAAAAANswIgQgUmaKf6fZSyF8qMbvYdoc4ca2Yz1K1eGS4oUE+tDDo3ww
# DQYJKoZIhvcNAQELBQAEggEALnZqmU1SGF28fV3Wyzh02Xniiv4QSmKXgjB30gog
# SpVrMU2FkClaMLRsUiFvP1IFGgu4FDpaO0kacwXFOIvSZw3+ZRjgBZ9Y13v2Sz2F
# QmEg5eQSY438hcBCUfBina3RD4vV9adD0cCaG0KSp4qUFRP9rGdnRc8PUpTG26ZB
# e/5rtj7hwCXH6dWdxjA4yWVJK3LTcSzffdcjusdkrpuJAO9//zPAITT+YX4laZnK
# 6EyvnAR8ovH+VCe2A/AbAu5H58xqe6DXjWgdRkchjr5haSfKlOsV/wNdlaMWn6P7
# sFfuHA3NYuKVk12dNMUFxSxdpcxOkQLrRDTUxJ4/UK8qYQ==
# SIG # End signature block
