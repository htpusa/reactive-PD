function pop = evolve(pop,nSteps)

% Run a population through a specified number of iterations of the discrete replicator
% dynamics
%
% USAGE:
%
%	updatedPopulation = evolve(population, numberOfTimeSteps)
%
% INPUTS:
%	population:			structure containing the population
%	numberOfTimeSteps:	for how many iterations the dynamics is run
%
% OUTPUTS:
%	updatedPopulation:	the input population with updated 'densities'
%						the previous densities are stored in a field 'history'
%						where each column is a time step
	
	% check for payoff matrix
	if ~isfield(pop,'payoffMatrix')
		pop = createPayoffMatrix(pop);
	end
	payoffMatrix = pop.payoffMatrix;
	
	densities = pop.densities;
	
	history = [];
	
	for step=1:nSteps
		avgPayoffInd = payoffMatrix*densities;
		avgPayoffPop = densities'*avgPayoffInd;
		history = [history densities];
		densities = times(densities,avgPayoffInd)/avgPayoffPop;
	end
	
	if ~isfield(pop, 'history')
		pop.history = history;
	else
		pop.history = [pop.history history];
	end
	pop.densities = densities;