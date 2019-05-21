function plotPop(pop, varargin)

% Plot the population in 'pop'. By default the current densities of all strategies.
%
% USAGE:
%
%	plotPop(population, varargin)
%
% INPUTS:
%	population:			structure containing the population to plot
%
% OPTIONAL INPUTS:
%	generation:		specify the generation that is plotted
%					default is the current population
%	mode:			choose what is plotted
%					default is strategy densities
%					you can specify several modes, each is plotted as a separate figure
%					'densities':	densities of all strategies
%					'p':			average p of the population
%					'q':			average q of the population
%					'payoff':		average payoff of the population
%					'cooperation':	average level of cooperation of the population
%	strategy:		integer, vector or matrix
%					plot the density of one or several strategies as a function of time
%					'strategy', [1, 2] plots the densities of strategies at indices 1 and 2
%

	densities = pop.densities;
	if ~isfield(pop,'history')
		t = 0;
	else
		t = size(pop.history,2);
	end
	plotDensities = 0;
	plotP = 0;
	plotQ = 0;
	plotPayoff = 0;
	plotCoop = 0;
	plotStrategy = {};
	
	if ~isempty(varargin) & rem(size(varargin,2),2)==0
		for i=1:2:size(varargin,2)
			switch varargin{1,i}
				case 'generation'
					if ~isfield(pop,'history')
						error('population has no history');
					elseif varargin{1,2}>size(pop.history,2)
						error('time point given exceeds population history');
					end
					densities = pop.history(:,varargin{1,i+1});
					t = varargin{1,i+1}-1;
				case 'mode'
					switch varargin{1,i+1}
						case 'densities'
							plotDensities = 1;
						case 'p'
							plotP = 1;
						case 'q'
							plotQ = 1;
						case 'payoff'
							plotPayoff = 1;
						case 'cooperation'
							plotCoop = 1; 
						otherwise
							warning(sprintf('no optional input named %s', varargin{1,i+1}));
					end
				case 'strategy'
					plotStrategy = [plotStrategy; varargin{1,i+1}];
				otherwise
					error('could not recognise optional input');
				end
		end
	elseif ~isempty(varargin) & rem(size(varargin,2),2)==1
		error('could not recognise optional input');
	end
	
	% plot densities, if selected or by default if no other option is chosen
	if plotDensities | ~any([plotP, plotQ, plotPayoff, plotCoop, ~isempty(plotStrategy)])
		figure;
		stem3(pop.strategies(:,1), pop.strategies(:,2), densities,'k');
		axis([0,1,0,1,0,1]);
		xlabel('p');
		ylabel('q');
		lgd = legend('str density','Location','northwest');
		title(lgd,sprintf('t = %i', t));
		title('Strategy densities');
	end
	
	% plot p
	if plotP
		if ~isfield(pop, 'history')
			warning('population has no history, could not plot p');
		else
			avgP = pop.strategies(:,1)'*pop.history;
			avgP = [avgP pop.strategies(:,1)'*pop.densities];
			tAxis = [0:size(pop.history,2)];
			figure;
			plot(tAxis,avgP,'LineWidth',2,'Color','k');
			axis([0,tAxis(end),0,1]);
			xlabel('t');
			ylabel('p');
			title('Average p');
		end
	end
	
	% plot q
	if plotQ
		if ~isfield(pop, 'history')
			warning('population has no history, could not plot q');
		else
			avgQ = pop.strategies(:,2)'*pop.history;
			avgQ = [avgQ pop.strategies(:,2)'*pop.densities];
			tAxis = [0:size(pop.history,2)];
			figure;
			plot(tAxis,avgQ,'LineWidth',2,'Color','k');
			axis([0,tAxis(end),0,1]);
			xlabel('t');
			ylabel('q');
			title('Average q');
		end
	end
	
	% plot average payoff
	if plotPayoff
		if ~isfield(pop, 'history')
			warning('population has no history, could not plot average payoff');
		else
			avgPayoffInd = pop.payoffMatrix*pop.history;
			avgPayoff = pop.history.*avgPayoffInd;
			avgPayoff = sum(avgPayoff,1);
			avgPayoff = [avgPayoff pop.densities'*(pop.payoffMatrix*pop.densities)];
			tAxis = [0:size(pop.history,2)];
			figure;
			plot(tAxis,avgPayoff,'LineWidth',2,'Color','k');
			axis([0,tAxis(end),0,pop.payoffs(1,1)]);
			xlabel('t');
			ylabel('payoff');
			title('Average payoff');
		end
	end
	
	% plot average c-level
	if plotCoop
		if ~isfield(pop, 'history')
			warning('population has no history, could not plot average level of cooperation');
		else
			avgCInd = pop.cMatrix*pop.history;
			avgC = pop.history.*avgCInd;
			avgC = sum(avgC,1);
			avgC = [avgC pop.densities'*(pop.cMatrix*pop.densities)];
			tAxis = [0:size(pop.history,2)];
			figure;
			plot(tAxis,avgC,'LineWidth',2,'Color','k');
			axis([0,tAxis(end),0,1]);
			xlabel('t');
			ylabel('c-level');
			title('Average level of cooperation');
		end
	end
	
	% plot strategies
	if ~isempty(plotStrategy)
		if ~isfield(pop, 'history')
			warning('population has no history, could not plot strategies');
		else
			for row=1:size(plotStrategy,1)
				if any(plotStrategy{row,1} > size(pop.densities,1))
					warning('strategy indicated exceeds size of the population');
				end
				indicesToPlot = plotStrategy{row,1}(plotStrategy{row,1} <= size(pop.densities,1));
				histories = pop.history(indicesToPlot,:);
				histories = [histories pop.densities(indicesToPlot)];
				tAxis = [0:size(pop.history,2)];
				figure;
				plot(tAxis,histories,'LineWidth',2);
				axis([0,tAxis(end),0,1]);
				xlabel('t');
				ylabel('density');
				title('Density of individual strategy');
				if numel(indicesToPlot) < 11
					legendStrings = {};
					for strI=1:numel(indicesToPlot)
						legendStrings = [legendStrings, sprintf('(%.2f, %.2f)', ...
							pop.strategies(indicesToPlot(strI),:))];
					end
					legend(legendStrings);
				else
					warning('not gonna print that many legends');
				end
			end
		end
	end
	