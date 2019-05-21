function pop = createCMatrix(pop)

% Creates a new field 'cMatrix' inside 'pop' that contains the c-level of row player
% against column player

	nStrategies = numel(pop.densities);
	cMatrix = zeros(nStrategies);
	
	for i=1:nStrategies
		for j=1:nStrategies
			stri = pop.strategies(i,:);
			strj = pop.strategies(j,:);
			cMatrix(i,j) = calcCLevel(stri,strj);
		end
	end

	pop.cMatrix = cMatrix;

end

	% calculate the c-level of strategy 'str1' against strategy 'str2'
	function cLevel = calcCLevel(str1, str2)
	
		p1=str1(1,1);
		q1=str1(1,2);
		p2=str2(1,1);
		q2=str2(1,2);

		cLevel = (q1 + (p1-q1)*q2)/(1-(p1-q1)*(p2-q2));
		
	end