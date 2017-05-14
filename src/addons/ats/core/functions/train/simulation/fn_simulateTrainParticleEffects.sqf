params ["_train"];
private _trainSpeed = _train getVariable ["ATRAIN_Local_Velocity",0];
private _trainCars = _train getVariable ["ATRAIN_Remote_Cars",[_train]];
{
	private _trainCar = _x;
	private _particleEffects = _trainCar getVariable ["ATRAIN_Remote_Particle_Effects",[]];
	private _particleSourcs = _trainCar getVariable ["ATRAIN_Local_Particle_Sources",[]];
	private _localCopy = _trainCar getVariable ["ATRAIN_Local_Copy", objNull];
	if(!isNull _localCopy) then {
		if(_trainSpeed == 0 && count _particleSourcs > 0) then {
			{
				deleteVehicle _x;
			} forEach _particleSourcs;
			_trainCar setVariable ["ATRAIN_Local_Particle_Sources",nil];
		};
		if(_trainSpeed != 0 && count _particleSourcs == 0) then {
			{
				_x params ["_particleType","_modelPosition"];
				if(typeName _modelPosition == "STRING") then {
					_modelPosition = _localCopy selectionPosition [_modelPosition, "Memory"];
				};
				
				if(_particleType == "steam") then {
					private _source = "#particlesource" createVehicleLocal (_localCopy modelToWorld _modelPosition);
											
					_source setParticleParams    
						[["\A3\data_f\ParticleEffects\Universal\smoke.p3d",1,0,1,0],"",    
						"billboard",    
						0,    
						1,    
						_modelPosition,    
						[0, 0, 2],    
						3,1.35,1,-0.1,    
						[0.5, 2],    
						[[1,1,1,0.25], [1,1,1,0.5], [1,1,1,0]],    
						[2,2],    
						0.1,    
						0.08,    
						"",    
						"",    
						_localCopy,
						0,    
						false,    
						0,    
						[[0,0,0,0]]];    
						 
					 _source setParticleRandom  
						[2,  
						[0,0,0.1],  
						[0,0,0.2],  
						1,  
						0.2,  
						[0.25,0.25,0.25,1],  
						0.01,  
						0.03,  
						10];    
						 
					_source setDropInterval 0.001;
					
					_particleSourcs pushBack _source;
				};
			} forEach _particleEffects;
			_trainCar setVariable ["ATRAIN_Local_Particle_Sources",_particleSourcs];
		};
	};
} forEach _trainCars;
