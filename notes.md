## SWF modifications
1. `TheRobotChronicles.swf`, scripts/frame 201, DoAction [18]:
   In `kv_v.lc = function() {}`, comment out this line:
```actionscript
kv_v.l_mcl.loadClip(_loc1_,kv_v.t_mc);
```

## POST /undefined/ExecuteAwardgiver

```json
{
  "awardCategory": "YmRCMVgOHFJFUQ==",  // bdB1XREQ
  "awardCode": "ckENBUpR",  // rA\nJQ
  "localId": "AANRRQ=="  // AANRRQ==
}
```

## Handling request

Codes are found in `config.xml`:
- Seems there is only one `awardCategory`: `SW Game 09`
- There are 7 `awardCode`s: `Cross1`-`Cross7`
- Seems there is only one `localId`: `1033`

- Relevant actionscript code: `com.lego.mln.external`, `CarrierService.execute()`
- The request is set to `carrierService.serviceUrl`, which is blank in `config.xml`
- That's why the request goes to `localhost/undefined/ExecuteAwardgiver`
- `com.lego.framework.application.Configuration.MLN_CARRIERSERVICE_XOR_KEY`:
  - `13bv9cyruhnflksjhtf+p1q`
- Calls `com.leg.framework.net.requests.XMLRequest_XOR.execute():
  - encrypts the parameters one by one with `com.lego.framework.net.encryption.XOR.encrypt():


## TODO
- find out how to decrypt the code
- find out how to login with MLN
