function animateHistory(pop, filename, varargin)

% Create a "movie" of the evolution of the population
%
% USAGE:
%	animateHistory(population, filename, varargin)
%
% INPUTS:
%	population: 		structure containing the population
%	filename:			where the mp4 created is saved
%
% OPTIONAL INPUTS:
%	interval:			the "framerate", ie, if 2, only every other generation is plotted
%
% NB: The function plots each time point. Do not close these windows while the function is
%		running.
%

	if ~isempty(varargin)
		switch varargin{1,1}
			case 'interval'
				interval = varargin{1,2};
		end
	else
		interval = 1;
	end

	videoFile = VideoWriter(filename,'MPEG-4');
	open(videoFile);
	
	for gen=1:interval:size(pop.history,2)
		densities = pop.history(:,gen);
		stem3(pop.strategies(:,1), pop.strategies(:,2), densities,'k');
		axis([0,1,0,1,0,1]);
		xlabel('p');
		ylabel('q');
		lgd = legend('str density','Location','northwest');
		title(lgd,sprintf('t = %i', gen-1));
		title('Strategy densities');
		frame = getframe(gcf);
		writeVideo(videoFile,frame);
	end
	
	stem3(pop.strategies(:,1), pop.strategies(:,2), pop.densities,'k');
	axis([0,1,0,1,0,1]);
	xlabel('p');
	ylabel('q');
	lgd = legend('str density','Location','northwest');
	title(lgd,sprintf('t = %i', size(pop.history,2)));
	title('Strategy densities');
	frame = getframe(gcf);
	writeVideo(videoFile, frame);
	close(videoFile);
	close;
	
	
	