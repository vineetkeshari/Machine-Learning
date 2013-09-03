How to run:
>> run('hw5')

Edit values in the first 10 lines of hw5.m to change parameters.

Files:
hw5.m : Main script
generateWorld.m : Generates a new world with randomly placed obstacles
takeAction.m : Makes the agent move on the grid

learnObstacles.m : Main loop for obstacle module
qObstacleStep.m : Q-learning step for obstacle module
getObstacleState.m : Determines state in one of four ways described in report

learnApproach.m : Main loop for approach module
qApproachStep.m : Q-learning step for approach module

testOnWorld.m : Tests for various combinations of the two modules
curvefit.m : Curve-fitting utility for graphs
