## SWF modifications
1. `TheRobotChronicles.swf`, scripts/frame 201, DoAction [18]:
   In `kv_v.lc = function() {}`, comment out this line:
```actionscript
kv_v.l_mcl.loadClip(_loc1_,kv_v.t_mc);
```
2. `scripts/frame 201`, `DoAction [10]`:
```actionscript
p.maxSpeed = 10  // from 30
```
3. `scripts/frame 201`, `DoAction [38]`:
```actionscript
this.speedActual = Math.round(Math.sqrt(this.vx * this.vx + this.vy * this.vy));
this.speedPerc = Math.abs(Math.min(1,this.speedActual / this.mechanics.speedMax));
if(this.isPlayer) {  // <-- added this
   this.speedActual *= 0.1;
}
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

.handle() is being called @ 20 FPS

## TODO
- respond with MLN rewards (printItem?)
- find out how to login with MLN

## Missions
1. Speed Inferno Challenge -- Cross2
2. Infestation -- Cross3
3. Towing The Line -- Cross4
4. Battle For The Skies -- N/A
5. Outriders Challenge -- N/A
6. Crane Quest -- Cross1
7. The Fall Of The Robot -- Cross5

## MLN Rewards
1. Crane Quest -- you're ready
2. Speed Inferno Challenge -- operation successful
3. Infestation -- Cross game rookie agents
4. Towing the Line -- Time and a half
5. The Fall of the Robot -- key to lego city

## Response
See `scripts/response.as` for details
