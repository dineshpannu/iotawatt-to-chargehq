# iotawatt-to-chargehq
IoTaWatt to Charge HQ integration

A PowerShell script which reads current values from your [IoTaWatt](https://iotawatt.com/) energy monitoring system and passes it to [Charge HQ](https://chargehq.net/). Charge HQ uses these values to charge your EV battery maximising solar energy use.

Developed against IoTaWatt with 13 CT sensors which track solar production and house usage, although the script can be used with as few as 2 CT sensors. At minimum we require 3 outputs from IoTaWatt:
* Solar production
* House consumption
* Net grid import/export (negative values being export)

## Configuration
Modify **$IOTAWATT_IP_ADDRESS**, **$IOTAWATT_GRIDNET_KEY**, **$IOTAWATT_PRODUCTION_KEY**, **$IOTAWATT_CONSUMPTION_KEY** and **$CHARGE_HQ_APIKEY** at the top of the script. You can get your Charge HQ API key using following the instructions [here](https://chargehq.net/kb/push-api).

Schedule the script to run every minute using the following trigger in Windows Task Scheduler:
![trigger - Screenshot 2022-12-11 192359](https://user-images.githubusercontent.com/11766807/206900800-6b03c142-124c-4e59-b450-79e2198b8c60.png)

The action should be to run PowerShell with the arguments `-File [script location]`:
![action - Screenshot 2022-12-11 192449](https://user-images.githubusercontent.com/11766807/206900854-b8dd2059-1553-432d-be39-0725d2669ef1.png)
