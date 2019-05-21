function newPop = addStrategy(strategy, pop, varargin)

% Add a strategy to an existing population
%
% USAGE:
%
%	updatedPopulation = addStrategy(newStrategies, population, varargin)
%
% INPUTS:
%	newStrategies:		a matrix containing the strategies to be added where each row
%						is a p,q pair
%	population:			structure containing a population
%
% OPTIONAL INPUTS:
%	density:			a column vector of densities for the new strategies
%						by default strategies are added with density 1/# of strategies
%
% OUTPUTS:
%	updatedPopulation:	structure containing the population after the strategies have been
%						added
%

	% check that the strategies are valid
	if any(strategy>=1) | any(strategy<=0)
		error('p and q have to be strictly between 0 and 1');
	end
	
	newPop = struct;
	nStrategies = numel(pop.densities);
	nStrategiesToAdd = size(strategy,1);
	
	if isempty(varargin)
		density = repmat(1/(nStrategiesToAdd+nStrategies), nStrategiesToAdd, 1);
	elseif size(varargin,2)==2
		switch varargin{1,1}
			case 'density'
				density = varargin{1,2};
				if sum(density) > 1
					error('density cannot be larger than 1');
				elseif size(density,1)~=nStrategiesToAdd
					error('density must be specified for all strategies added');
				end
			otherwise
				error('could not recognise optional input');
		end
	else
		error('could not recognise optional input');
	end
	
	newPop.densities = [pop.densities*(1-sum(density)); density];
	newPop.strategies = [pop.strategies; strategy];
	newPop.payoffs = pop.payoffs;
	
	if isfield(pop,'history')
		newPop.history = [pop.history; zeros(nStrategiesToAdd,size(pop.history,2))];
	end