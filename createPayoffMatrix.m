function pop = createPayoffMatrix(pop)

% Creates a new field 'payoffMatrix' inside 'pop' that contains the payoff of row player
% against column player

	if ~isfield(pop, 'cMatrix')
		pop = createCMatrix(pop);
	end
	nStrategies = numel(pop.densities);
	payoffMatrix = zeros(nStrategies);
	
	T = pop.payoffs(1,1);
	R = pop.payoffs(1,2);
	P = pop.payoffs(1,3);
	S = pop.payoffs(1,4);
	
	for i=1:nStrategies
		for j=1:nStrategies
			ci = pop.cMatrix(i,j);
			cj = pop.cMatrix(j,i);
			payoffMatrix(i,j) = ci*(cj*(R-S-T+P)+S-P)+cj*(T-P)+P;
		end
	end

	pop.payoffMatrix = payoffMatrix;