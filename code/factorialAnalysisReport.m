%% factorialAnalysisReport
% 
% Prints the summary report of the factorial analyses on the requested 
% experimental collections.

%% Synopsis
%
%   [] = factorialAnalysisReport(tag, varargin)
%  
%
% *Parameters*
%
% * *|tag|* - the tag of the analysis to be reported.
% * *|varargin|* - the identifiers of the tracks to print.
%
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

function [] = factorialAnalysisReport(tag, varargin)

    % check the number of input arguments
    narginchk(2, inf);

    % check that identifier of the analysis is a non-empty string
    validateattributes(tag,{'char', 'cell'}, {'nonempty', 'vector'}, '', 'tag');
    
    if iscell(tag)
        % check that tag is a cell array of strings with one element
        assert(iscellstr(tag) && numel(tag) == 1, ...
            'MATTERS:IllegalArgument', 'Expected tag to be a cell array of strings containing just one string.');
    end
    
    % remove useless white spaces, if any, and ensure it is a char row
    tag = char(strtrim(tag));
    tag = tag(:).';

    tracks = length(varargin);
    
    for t = 1:tracks
        
        % check that trackID is a non-empty string
        validateattributes(varargin{t}, {'char', 'cell'}, {'nonempty', 'vector'}, '', 'trackID');
        
        if iscell(varargin{t})
            
            % check that trackID is a cell array of strings with one element
            assert(iscellstr(varargin{t}) && numel(varargin{t}) == 1, ...
                'MATTERS:IllegalArgument', 'Expected trackID to be a cell array of strings containing just one string.');
        end
        
        % remove useless white spaces, if any, and ensure it is a char row
        varargin{t} = char(strtrim(varargin{t}));
        varargin{t} = varargin{t}(:).';
        
    end;

    % setup common parameters
    common_parameters;    

    % turn on logging
    delete(EXPERIMENT.pattern.logFile.analysisReport(tag));
    diary(EXPERIMENT.pattern.logFile.analysisReport(tag));
        
    % start of overall computations
    startComputation = tic;

    fprintf('\n\n######## Printing summary report of the %s analyses (%s) ########\n\n', ...
        EXPERIMENT.analysis.(tag).name, EXPERIMENT.label.paper);
        
    fprintf('+ Settings\n');
    fprintf('  - computed on %s\n', datestr(now, 'yyyy-mm-dd at HH:MM:SS'));
    fprintf('  - tracks: \n    * %s\n\n', strjoin(varargin, '\n    * '));
     
    fprintf('  - analysis type:\n');
    fprintf('    * %s\n', EXPERIMENT.analysis.(tag).name);
    fprintf('    * %s\n', EXPERIMENT.analysis.(tag).description);
   
    fprintf('+ Loading analyses\n');
    
    % the data structures
    anovaTable = [];
    soa = [];
        
    % for each track
    for t = 1:tracks
        
        trackID = varargin{t};
        
        fprintf('  - track: %s \n', trackID);
        
        % for each measure
        for m = 1:EXPERIMENT.measure.number
            
            fprintf('    * measure: %s \n', EXPERIMENT.measure.getShortName(m));
            
            measureID = EXPERIMENT.pattern.identifier.measure(EXPERIMENT.measure.list{m}, trackID);
            
            for lug = 1:EXPERIMENT.taxonomy.lug.number
                
                lugType = EXPERIMENT.taxonomy.lug.list{lug};
                
                fprintf('      # lexical unit generator: %s \n', EXPERIMENT.taxonomy.(lugType).name);
                
                try
                    
                    anovaTableID = EXPERIMENT.pattern.identifier.anovaTable(EXPERIMENT.analysis.(tag).id, lugType, measureID);
                    anovaSoAID = EXPERIMENT.pattern.identifier.anovaSoA(EXPERIMENT.analysis.(tag).id, lugType, measureID);
                    
                    serload(EXPERIMENT.pattern.file.anova(trackID, EXPERIMENT.analysis.(tag).id, lugType, measureID), anovaTableID, anovaSoAID);
                    
                    eval(sprintf('anovaTable.(''%1$s'').(''%2$s'').(''%3$s'') = %4$s;', trackID, EXPERIMENT.measure.list{m}, lugType, anovaTableID));
                    eval(sprintf('soa.(''%1$s'').(''%2$s'').(''%3$s'') = %4$s;', trackID, EXPERIMENT.measure.list{m}, lugType, anovaSoAID));
                    
                    clear(anovaTableID, anovaSoAID);
                    
                catch exception
                    % if the measure is not available, set it empty
                    eval(sprintf('anovaTable.(''%1$s'').(''%2$s'').(''%3$s'') = [];', trackID, EXPERIMENT.measure.list{m}, lugType));
                    eval(sprintf('soa.(''%1$s'').(''%2$s'').(''%3$s'') = [];', trackID, EXPERIMENT.measure.list{m}, lugType));
                    
                end;
                
            end; % lugType
            
        end % measures
        
    end; % track
    
    clear measureID anovaTableID anovaSoAID;
    
    
    fprintf('+ Printing the report\n');    

    % the file where the report has to be written
    fid = fopen(EXPERIMENT.pattern.file.analysisReport(EXPERIMENT.analysis.(tag).id), 'w');


    fprintf(fid, '\\documentclass[11pt]{article} \n\n');

    fprintf(fid, '\\usepackage{amsmath}\n');
    fprintf(fid, '\\usepackage{multirow}\n');
    fprintf(fid, '\\usepackage{colortbl}\n');
    fprintf(fid, '\\usepackage{lscape}\n');
    fprintf(fid, '\\usepackage{pdflscape}\n');            
    fprintf(fid, '\\usepackage[a2paper]{geometry}\n\n');
    
    fprintf(fid, '\\usepackage{xcolor}\n');
    fprintf(fid, '\\definecolor{lightgrey}{RGB}{219, 219, 219}\n');
    fprintf(fid, '\\definecolor{verylightblue}{RGB}{204, 229, 255}\n');
    fprintf(fid, '\\definecolor{lightblue}{RGB}{124, 216, 255}\n');
    fprintf(fid, '\\definecolor{blue}{RGB}{32, 187, 253}\n');

    fprintf(fid, '\\begin{document}\n\n');

    fprintf(fid, '\\title{Summary Report on %s Analyses}\n\n', EXPERIMENT.analysis.(tag).name);

    fprintf(fid, '\\maketitle\n\n');
    
    fprintf(fid, 'Tracks:\n');
    fprintf(fid, '\\begin{itemize}\n');
    
    % for each track
    for t = 1:tracks
        fprintf(fid, '\\item %s\n', EXPERIMENT.(varargin{t}).name);
    end;
    
    fprintf(fid, '\\end{itemize}\n');
    
    
    evalf(EXPERIMENT.analysis.(tag).report, {'fid', 'anovaTable', 'soa'}, {});
           
    fprintf(fid, '\\end{document} \n\n');
    
    
    fclose(fid);
    
    
    fprintf('\n\n######## Total elapsed time for printing summary report of the %s analyses (%s): %s ########\n\n', ...
            EXPERIMENT.analysis.(tag).name, EXPERIMENT.label.paper, elapsedToHourMinutesSeconds(toc(startComputation)));
         
    diary off;
    
end

