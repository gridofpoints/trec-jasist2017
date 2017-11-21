%% measureFactorialAnalysis
% 
% Performs a factorial analysis across measures on the considered experimental
% collections.

%% Synopsis
%
%   [] = measureFactorialAnalysis(trackID, tag, startMeasure, endMeasure)
%  
%
% *Parameters*
%
% * *|trackID|* - the identifier of the track for which the processing is
% performed.
% * *|tag|* - the tag of the analysis to be conducted.
% * *|startMeasure|* - the index of the start measure to analyse. Optional.
% * *|endMeasure|* - the index of the end measure to analyse. Optional.
%
% *Returns*
%
% Nothing
%

%% Information
% 
% * *Author*: <mailto:ferro@dei.unipd.it Nicola Ferro>
% * *Version*: 1.00
% * *Since*: 1.00
% * *Requirements*: Matlab 2015b or higher
% * *Copyright:* (C) 2016 <http://ims.dei.unipd.it/ Information 
% Management Systems> (IMS) research group, <http://www.dei.unipd.it/ 
% Department of Information Engineering> (DEI), <http://www.unipd.it/ 
% University of Padua>, Italy
% * *License:* <http://www.apache.org/licenses/LICENSE-2.0 Apache License, 
% Version 2.0>

%%
%{
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
      http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
%}

%%

function [] = measureFactorialAnalysis(trackID, tag, startMeasure, endMeasure)

    % check the number of input arguments
    narginchk(2, 4);
    
     % check that trackID is a non-empty string
    validateattributes(trackID,{'char', 'cell'}, {'nonempty', 'vector'}, '', 'trackID');
    
    if iscell(trackID)
        % check that trackID is a cell array of strings with one element
        assert(iscellstr(trackID) && numel(trackID) == 1, ...
            'MATTERS:IllegalArgument', 'Expected trackID to be a cell array of strings containing just one string.');
    end
    
    % remove useless white spaces, if any, and ensure it is a char row
    trackID = char(strtrim(trackID));
    trackID = trackID(:).';
    
    % check that identifier is a non-empty string
    validateattributes(tag,{'char', 'cell'}, {'nonempty', 'vector'}, '', 'tag');
    
    if iscell(tag)
        % check that tag is a cell array of strings with one element
        assert(iscellstr(tag) && numel(tag) == 1, ...
            'MATTERS:IllegalArgument', 'Expected tag to be a cell array of strings containing just one string.');
    end
    
    % remove useless white spaces, if any, and ensure it is a char row
    tag = char(strtrim(tag));
    tag = tag(:).';

    % setup common parameters
    common_parameters;    
    
    if nargin == 4
        validateattributes(startMeasure, {'numeric'}, ...
            {'nonempty', 'integer', 'scalar', '>=', 1, '<=', EXPERIMENT.measure.number }, '', 'startMeasure');
        
        validateattributes(endMeasure, {'numeric'}, ...
            {'nonempty', 'integer', 'scalar', '>=', startMeasure, '<=', EXPERIMENT.measure.number }, '', 'endMeasure');

    else 
        startMeasure = 1;
        endMeasure = EXPERIMENT.measure.number;
    end;
    
    % turn on logging
    delete(EXPERIMENT.pattern.logFile.analysis(tag, trackID));
    diary(EXPERIMENT.pattern.logFile.analysis(tag, trackID));

    % start of overall computations
    startComputation = tic;

    fprintf('\n\n######## Computing %s analyses on collection %s (%s) ########\n\n', ...
        EXPERIMENT.analysis.(tag).name, EXPERIMENT.(trackID).name, EXPERIMENT.label.paper);
        
    fprintf('+ Settings\n');
    fprintf('  - computed on %s\n', datestr(now, 'yyyy-mm-dd at HH:MM:SS'));
    fprintf('  - significance level alpha: %f\n', EXPERIMENT.analysis.alpha);
     
    if ~isempty(EXPERIMENT.analysis.maxTopic)
        fprintf('  - maximum number of analysed topics: %d\n', EXPERIMENT.analysis.maxTopic);
    else
        fprintf('  - maximum number of analysed topics: all\n');
    end;
    
    fprintf('  - analysis type:\n');
    fprintf('    * %s\n', EXPERIMENT.analysis.(tag).name);
    fprintf('    * %s\n', EXPERIMENT.analysis.(tag).description);
   
    fprintf('  - slice \n');
    fprintf('    * start measure: %d (%s)\n', startMeasure, EXPERIMENT.measure.getShortName(startMeasure));
    fprintf('    * end measure: %d (%s)\n', endMeasure, EXPERIMENT.measure.getShortName(endMeasure));

    
	fprintf('\n+ Loading measures\n');
	measures = cell(1, endMeasure - startMeasure + 1);
	
    % for each measure
    for m = startMeasure:endMeasure
        
        % if startMeasure is not 1, we need to properly index within the
        % array
        idx = m - startMeasure + 1;
        
        fprintf('  - loading %s\n', EXPERIMENT.measure.getShortName(idx));
        
        measureID = EXPERIMENT.pattern.identifier.measure(EXPERIMENT.measure.list{idx}, trackID);
        serload(EXPERIMENT.pattern.file.measure(trackID, measureID), measureID);
        
        eval(sprintf('measures{%d} = %s;', idx, measureID));
        
        % free space
        clear(measureID);
        
	end; % measures
        
    fprintf('\n');
    
    for lug = 1:EXPERIMENT.taxonomy.lug.number
        
        start = tic;
        
        lugType = EXPERIMENT.taxonomy.lug.list{lug};
        
        fprintf('+ Performing analyses using lexical unit generators: %s\n', EXPERIMENT.taxonomy.(lugType).name);
        
        measureID = EXPERIMENT.pattern.identifier.measure(tag, trackID);
        
        anovaTableID = EXPERIMENT.pattern.identifier.anovaTable(tag, lugType, measureID);
        anovaStatsID = EXPERIMENT.pattern.identifier.anovaStats(tag, lugType, measureID);
        anovaSoAID = EXPERIMENT.pattern.identifier.anovaSoA(tag, lugType, measureID);
        
        
        evalf(EXPERIMENT.analysis.(tag).analyse, ...
            {'measures', 'lugType'}, ...
            {anovaTableID, anovaStatsID, anovaSoAID});
                
        fprintf('  + saving analyses\n');
        sersave(EXPERIMENT.pattern.file.anova(trackID, tag, lugType, measureID), ...
            anovaTableID(:), anovaStatsID(:), anovaSoAID(:))
        
        % free space
        clear(anovaTableID, anovaStatsID, anovaSoAID);
        
        fprintf('  +  elapsed time: %s\n', elapsedToHourMinutesSeconds(toc(start)));
    end; % lug
    
    
    fprintf('\n\n######## Total elapsed time for computing %s analyses on collection %s (%s): %s ########\n\n', ...
         EXPERIMENT.analysis.(tag).name, EXPERIMENT.(trackID).name, EXPERIMENT.label.paper, ....
         elapsedToHourMinutesSeconds(toc(startComputation)));
    
    diary off;
    
end

