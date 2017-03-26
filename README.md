# Advanced Train Simulator

Created by Duda

**Features:**

**Directions:**

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
