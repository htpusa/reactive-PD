% This script runs the simulation presented in Nowak and Sigmund's 1992 paper "Tit for tat
% in heterogeneous populations" and creates the plots shown in the article. 

rng('shuffle');

% "Axelrod payoff values"
T = 5;
R = 3;
P = 1;
S = 0;

nStrategies = 100;
nIterations = 1000;

pop = createRandomPopulation(nStrategies-1, [T, R, P, S]);

% add TFT
pop = addStrategy([0.99, 0.01],pop);

pop = evolve(pop,nIterations);

% plot the densities at different time points
plotPop(pop,'generation',1);
plotPop(pop,'generation',19);
plotPop(pop,'generation',99);
plotPop(pop,'generation',149);
plotPop(pop,'generation',199);
plotPop(pop);

% plot the rest
plotPop(pop, 'mode', 'p');
plotPop(pop, 'mode', 'q');
plotPop(pop, 'mode', 'payoff');

% uncomment the next line to create an mp4 "film" 'movie.mp4' of the simulation
%animateHistory(pop, 'movie', 'interval', 5);