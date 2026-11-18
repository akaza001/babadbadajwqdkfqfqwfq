-- Example project values only. Merge into the host Config, do not overwrite its schema.
return {
 cast={minDistance=14,maxDistance=36,sweepSeconds=.8,timeoutSeconds=12,maxInputBackdate=.3,maxInputFuture=.05,strongMin=.76,strongMax=1},
 toolLevels={{pullDurationSeconds=6},{pullDurationSeconds=5.5},{pullDurationSeconds=5}},
 pull={distanceExtraSeconds=6},
}
