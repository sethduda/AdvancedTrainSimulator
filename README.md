# Advanced Train Simulator

Created by Duda

**Features:**

 - Drive and ride on trains in Arma 3!
 - Supports all existing trains and tracks on Tanoa.
 - Create custom tracks by placing APEX track objects in the editor (see directions below).
 - Multiplayer support. Mod only required to be installed on server.
 - Supports APEX and CUPS train models.
 - Supports APEX tracks (CUPS tracks still in the works!).

**Directions:**
 
While outside of a train, there are a few actions you can perform. Look directly at the train to get these possible actions:
 
 - Get in Train as Driver: When looking at a train engine, you'll get this option to become the driver of the train. See train driver controls below.
 - Disconnect Car: When looking at a car connected to a train, you'll get this option. This will disconnect the car from the train. The train cannot be moving.
 - Ride Train: When looking at a train car (attached to a train someone else is driving) you'll get this option to ride the train. See train passenger controls below.
 
Train Driver Controls:

 - Move Forward (defaults to W key): Speed up the train
 - Move Backward (defaults to S key): Slow down the train
 - Turn Left (defaults to A key): Controls track switching. Hold "Move Left" as you pass an intersection to direct the train down the left-most path.
 - Turn Right (defaults to D key): Controls track switching. Hold "Move Right" as you pass an intersection to direct the train down the right-most path.
 - Enabled / Disable Cruise Control (C key): When enabled, the train will maintain its current speed automatically (even if you jump out of the train - runaway train!)
 - Break (B key): A faster way to slow down your train besides holding down the Move Backwards key
 - Exit Train (delete key): Exit the current train.
 
 Note: If you don't hold left or right while passing an intersection, the train will choose the path that requires the least amount of turning.
 
Train Passenger Controls:

Exit Train (delete key): Exit the current train
 
Train Placement

Train objects can be placed on any tracks, including custom tracks. The train must be placed on top of the track. It's not important that the train object lines up perfectly. As long as it's on top of the track, it will work. All existing trains on the Tanoa map will work as-is. Currently, all of the train objects from APEX and CUPS are supported.
 
Track Placement

Custom track objects can be placed via the editor on any map. They can also connect on to the existing tracks placed on Tanoa. Only the track objects included with APEX are supported.
 
1. All tracks must be terminated with the track termination object. If you don't do this, the train won't be able to follow your track that has no termination.

track_placement_1.jpg
 
2. Intersections must use the intersection track objects. Intersection track objects can be place on top of other tracks. You cannot create intersections using straight or curved tracks.
 
track_placement_2.jpg

**Installation:**

 1. Subscribe via steam: xxxxxx or download latest release from https://github.com/sethduda/AdvancedTrainSimulator/releases
 2. If installing this on a server, add the addon to the -serverMod command line option. It's required on the server side and is not required for clients.

**FAQ**

*Battleye kicks me when I try to do xyz. What do I do?*

You need to configure Battleye rules on your server. Below are the files you need to configure: 

setvariable.txt 

Add the following exclusions to the end of all lines starting with 4, 5, 6, or 7 if they contain "" (meaning applies to all values): 

!"ATRAIN_"

setvariableval.txt 

If you have any lines starting with 4, 5, 6, or 7 and they contain "" (meaning applies to all values) it's not going to work. Either remove the line or explicitly define the values you want to kick. Since the values of the variables above can vary, I don't know of a good way to define an exclusion rule. 

Also, it's possible there are other battleye filter files that can cause issues. If you check your battleye logs you can figure out which file is causing a problem.

*My server is blocking script remote executions. How do I fix this?*

Most likely your server is setup with a white list for remote executions. In order to fix this, you need to modify your mission's description.ext file, adding the following CfgRemoteExec rules. If using InfiStar you should edit your cfgremoteexec.hpp instead of the description.ext file. See https://community.bistudio.com/wiki/Arma_3_Remote_Execution for more details on CfgRemoteExec.
	
```
class CfgRemoteExec
{
	class Functions
	{
		class ATRAIN_fnc_unregisterTrainAndDriver { allowedTargets=2; }; 
		class ATRAIN_fnc_registerTrainAndDriver { allowedTargets=2; }; 
		class ATRAIN_fnc_updateTrackMap { allowedTargets=2; }; 
		class ATRAIN_fnc_hideTrainObjectGlobal { allowedTargets=2; }; 
		class ATRAIN_fnc_hidePlayerObjectGlobal { allowedTargets=2; };
	};
};
```
 
**Issues & Feature Requests**

https://github.com/sethduda/AdvancedTrainSimulator/issues 

---

The MIT License (MIT)

Copyright (c) 2017 Seth Duda

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
