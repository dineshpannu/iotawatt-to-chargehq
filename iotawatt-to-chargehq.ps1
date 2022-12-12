###############################################################################
# IoTaWatt to Charge HQ Integration
#
# Modify these values to suit:
#

$IOTAWATT_IP_ADDRESS = ""
$IOTAWATT_GRIDNET_KEY = "Mains"
$IOTAWATT_PRODUCTION_KEY = "Solar"
$IOTAWATT_CONSUMPTION_KEY = "Consumption"
$CHARGE_HQ_APIKEY = ""

#
#
###############################################################################


$IOTAWATT_URI = "http://$($IOTAWATT_IP_ADDRESS)/query?select=[$($IOTAWATT_GRIDNET_KEY).watts,$($IOTAWATT_PRODUCTION_KEY).watts,$($IOTAWATT_CONSUMPTION_KEY).watts]&begin=s-1m&end=s&group=all&header=no"
$CHARGE_HQ_URI = "https://api.chargehq.net/api/public/push-solar-data"

function ConvertToKw($power) {
    $kW = $power/1000

    return $kW
}

$payload = @{
    "apiKey" = $CHARGE_HQ_APIKEY;
    "error" = "";
}

#Write-Host $($IOTAWATT_URI)
try {
    $json = Invoke-RestMethod -Uri $($IOTAWATT_URI)
    #Write-Host ($json | ConvertTo-Json)

    if ($null -ne $json -and $json.Count -gt 0) {
    
        $siteMeters = @{}
        $values = $json[0]
    
        $siteMeters["net_import_kw"] = ConvertToKw $values[0]
        $siteMeters["production_kw"] = ConvertToKw $values[1]
        $siteMeters["consumption_kw"] = ConvertToKw $values[2]
    
        $payload["siteMeters"] = $siteMeters
    }
}
catch {
    # Note that value__ is not a typo.
    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    
    $payload["error"] = "$($_.Exception.Response.StatusCode.value__) $($_.Exception.Response.StatusDescription)"
    if ($null -ne $_.ErrorDetails.Message)
    {
        $json = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "Message:" $json.error
        if ($null -ne $json.error)
        {
            $payload["error"] += ": $($json.error)"
        }
    }
}


$payloadJson = $payload | ConvertTo-Json
#Write-Host $payloadJson

$response = Invoke-RestMethod -Uri $CHARGE_HQ_URI -Method Post -Body $payloadJson -ContentType "application/json"
Write-Host $response
#$response | Out-File -FilePath .\hello.txt -Append
