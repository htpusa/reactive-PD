function pop = createRandomPopulation(nStrategies, payoffs)

% Create a population of a set number of random strategies with equal densities.
%
% USAGE:
%
%	population = createRandomPopulation(numberOfStrategies, payoffValues);
%
% INPUTS:
%	numberOfStrategies:		integer to determine the size of the population
%	payoffValues:			row vector [T R P S] that contains the payoff values
%
% OUTPUTS:
%	population:				structure containing the population created
%							

	pop = struct('densities', repmat(1/nStrategies,nStrategies,1), 'payoffs', payoffs, ...
				'strategies',rand(nStrategies,2));
	
	