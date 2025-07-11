# The Robot Chronicles

A server to provide the Flash files and My Lego Network integration for
The Robot Chronicles, an old Flash-based game by LEGO®.

> [!Note]
> LEGOⓇ is a trademark of the LEGO Group. The LEGO Group is not affiliated with 
> this project or its maintainers, has not endorsed or authorized its operation,
> and is not liable for any safety issues in relation to its operation.
>
> No profit is being derived from this project, it is simply a restoration for
> restoration's sake, to enable players to play the games they grew up with.
>
> The operation of this project follows existing precedents and guidelines set
> by the LEGO Group (and other organizations) in relation to fan projects and
> abandonware (including the existance of other such projects). Should any
> party with claim to the intillectual property used in this project have issue
> with its operation, please contact us immediately and we will take action as
> soon as possible to resolve, or ultimately remove this project if necessary.

## SWF modifications
1. `TheRobotChronicles.swf`, scripts/frame 201, DoAction [18]:
   In `kv_v.lc = function() {}`, comment out this line to disable tracking:
```diff
- kv_v.l_mcl.loadClip(_loc1_,kv_v.t_mc);
+ // kv_v.l_mcl.loadClip(_loc1_,kv_v.t_mc);
```

2. `scripts/frame_201`, `DoAction [42]`: Lowered the max speed
```diff
this.setMechanics = function(speed, acceleration, grip, steering, offroad) {
-   this.speedMax = (speed + 1) * 1.25;
+   this.speedMax = (speed + 1) * 1.25 * 0.75;
```

3. `scripts/frame_201`, `DoAction [42]`: Lowered the skid effect
```diff
if(this.control.LEFT) {
-  this.roll -= 2;
+  this.roll -= 1;
```
```diff
else if(this.control.RIGHT) {
-   this.roll += 2;
+   this.roll += 1;
```

4. `scripts/frame_201`, `DoAction [23]`: Enabled `test` as a cheat code
```diff
- if(code == "hooloovoo" && dialogue("CHT_allowTM") == "TRUE")
+ if((code == "hooloovoo" || code == "test") && dialogue("CHT_allowTM") == "TRUE")
```

5. `scripts/frame_201`, `DoAction [47]`: Fixed FPS reporting (only visible in test mode)
```diff
this.handle = function() {
+   this.fpsCounter++

...

this.calcFPS = function() {  // replace entire body with below
+   var _loc2_ = getTimer();
+   if(!isNaN(this.nextTimeFps) && _loc2_ < this.nextTimeFps) {
+      return this.fps;
+   }
+   this.nextTimeFps = _loc2_ + 1000;
+   var _loc3_ = this.fpsCounter;
+   this.fpsCounter = 0;
+   this.frameDuration = this.currentTime - this.previousTime;
+   this.previousTime = this.currentTime;
+   this.currentTime = getTimer();
+   return _loc3_;
}
```

6. `scripts/frame_201`, `DoAction [47]`: Lock the framerate
```diff
this.handle = function() {
+   this.currentTime2 = getTimer();
+   this.frameInterval = 1000 / this.framesPerSecond;
+   if (!isNaN(this.nextTime2) && this.currentTime2 < this.nextTime2) {
+     return undefined;
+   }
+   this.nextTime2 = this.currentTime2 + this.frameInterval;
    this.fpsCounter++;
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
