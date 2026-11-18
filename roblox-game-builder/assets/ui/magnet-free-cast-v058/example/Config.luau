-- Originating project values. Merge relevant keys into the host Config.
return {
 cast={minDistance=4,maxDistance=36,nearWaterDistance=18,sweepSeconds=.8,timeoutSeconds=12,maxInputBackdate=.3,maxInputFuture=.05,strongMin=.76,strongMax=1},
 toolLevels={{pullDurationSeconds=6},{pullDurationSeconds=5.5},{pullDurationSeconds=5}},pull={distanceExtraSeconds=6},
}
