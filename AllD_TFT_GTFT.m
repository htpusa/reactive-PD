% Alternative version of the Nowak and Sigmund (1992) simulation that explicitly inserts
% All-D, TFT, and GTFT, and tracks their densities.

rng('shuffle');

% "Axelrod payoff values"
T = 5;
R = 3;
P = 1;
S = 0;

nStrategies = 100;
nIterations = 1000;

pop = createRandomPopulation(nStrategies-3, [T, R, P, S]);

% add the three focal strategies
pop = addStrategy([0.01, 0.01; 0.99, 0.01; 0.99, 0.33], pop);

pop = evolve(pop,nIterations);

% plot the evolution of the three focal strategies
plotPop(pop,'strategy', [98, 99, 100]);