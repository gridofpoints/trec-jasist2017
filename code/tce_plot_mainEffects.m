%% tce_plot_mainEffects
% 
% Produces the main effects plot for a three factors, mixed effects, 
% repeated measures GLMM considering topics as random factor 
% (repeated measures/within-subject) and system components as fixed factors.

%% Synopsis
%
%   [] = tce_plot_mainEffects(measures, measureID, trackID, lugType)
%  
% *Parameters*
%
% * *|measures|* - a set of measures. 
% * *|measureID|* - the name (id) of the measure. 
% * *|trackID|* - the identifier of the track for which the processing is
% performed.
% * *|lugType|* - the type of the lexical unit generator which has to be 
% used to  list systems. The following values can be used: _|lugall|_ to 
% list all the systems; _|stem|_ to list only systems using stemmers;  
% _|grams|_ to list only systems using n-grams.
%
% *Returns*
%
% Nothing.

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

function [] = tce_plot_mainEffects(measures, measureID, trackID, lugType)

    % check the number of input parameters
    narginchk(4, 4);

    % load common parameters
    common_parameters


    % check that measures is a non-empty table
    validateattributes(measures, {'table'}, {'nonempty'}, '', 'measures', 1);
    
    % check that measureShortName is a non-empty string
    validateattributes(measureID,{'char', 'cell'}, {'nonempty', 'vector'}, '', 'measureShortName');
    
    if iscell(measureID)
        % check that measureShortName is a cell array of strings with one element
        assert(iscellstr(measureID) && numel(measureID) == 1, ...
            'MATTERS:IllegalArgument', 'Expected measureShortName to be a cell array of strings containing just one string.');
    end
    
    % remove useless white spaces, if any, and ensure it is a char row
    measureID = char(strtrim(measureID));
    measureID = measureID(:).';
    
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
    
    % check that lugType is a non-empty string
    validateattributes(lugType, ...
        {'char', 'cell'}, {'nonempty', 'vector'}, '', ...
        'lugType');
    
    % check that lugType assumes a valid value
    validatestring(lugType, ...
        EXPERIMENT.taxonomy.lug.list, '', 'lugType');
    
    % remove useless white spaces, if any, and ensure it is a char row
    lugType = char(lower(strtrim(lugType)));
    lugType = lugType(:).';  
        
    % if a maximum number of topics to be analysed is speficied, reduce the 
    % dataset to that number 
    if ~isempty(EXPERIMENT.analysis.maxTopic)
        measures = measures(1:EXPERIMENT.analysis.maxTopic, : );
    end;
    
    
    % get the labels of the topics (subjects/cell contents)
    topics = measures.Properties.RowNames;
    topics = topics(:).';
    m = length(topics);

    switch lugType
        
        case 'lugall'
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number *  EXPERIMENT.taxonomy.lugall.number * EXPERIMENT.taxonomy.model.number * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number * m;
            
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (lugall)
            factorC = cell(1, N);  % grouping variable for factorC (model)
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for lugall = 1:EXPERIMENT.taxonomy.lugall.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                
                                range = (currentElement-1)*m+1:currentElement*m;
                                
                                % copy the measures in the correct range of the data
                                data(range) = measures{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                    EXPERIMENT.taxonomy.lugall.id{lugall}, EXPERIMENT.taxonomy.model.id{model}, ...
                                    EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query})};
                                
                                % set the correct grouping variables
                                subject(range) = topics;
                                factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                                factorB(range) = EXPERIMENT.taxonomy.lugall.id(lugall);
                                factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                                
                                % increment the current element counter
                                currentElement = currentElement + 1;
                                
                            end; % query
                        end; % ltr
                    end; % model
                end; % stem
            end; % stop
            
        case 'stem'
            
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.stem.number * EXPERIMENT.taxonomy.model.number * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number * m;
            
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (stemmer)
            factorC = cell(1, N);  % grouping variable for factorC (model)
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for stem = 1:EXPERIMENT.taxonomy.stem.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                
                                range = (currentElement-1)*m+1:currentElement*m;
                                
                                % copy the measures in the correct range of the data
                                data(range) = measures{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                    EXPERIMENT.taxonomy.stem.id{stem}, EXPERIMENT.taxonomy.model.id{model}, ...
                                    EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query})};
                                
                                % set the correct grouping variables
                                subject(range) = topics;
                                factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                                factorB(range) = EXPERIMENT.taxonomy.stem.id(stem);
                                factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                                
                                % increment the current element counter
                                currentElement = currentElement + 1;
                                
                            end; % query
                        end; % ltr
                    end; % model
                end; % stem
            end; % stop
            
        case 'grams'
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.grams.number * EXPERIMENT.taxonomy.model.number  * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number * m;
            
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (grams)
            factorC = cell(1, N);  % grouping variable for factorC (model)
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for grams = 1:EXPERIMENT.taxonomy.grams.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                
                                range = (currentElement-1)*m+1:currentElement*m;
                                
                                % copy the measures in the correct range of the data
                                data(range) = measures{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                    EXPERIMENT.taxonomy.grams.id{grams}, EXPERIMENT.taxonomy.model.id{model}, ...
                                    EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query})};
                                
                                % set the correct grouping variables
                                subject(range) = topics;
                                factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                                factorB(range) = EXPERIMENT.taxonomy.grams.id(grams);
                                factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                                
                                % increment the current element counter
                                currentElement = currentElement + 1;
                                
                            end; % query
                        end; % ltr
                    end; % model
                end; % stem
            end; % stop
            
        otherwise
            error('Unexpected lexical unit generator type');
    end;
    
    data = data(:);
    factorA = factorA(:);
    factorB = factorB(:);
    factorC = factorC(:);
                         
    currentFigure = figure('Visible', 'off');
    
       maineffectsplot(data, {factorA, factorB, factorC}, ...
            'VarNames', {EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name});
        
       currentFigure.Children(3).FontSize = 18;
       currentFigure.Children(3).YLabel.String = sprintf('%s Marginal Mean', EXPERIMENT.measure.(measureID).shortName);
       currentFigure.Children(3).YLabel.FontSize = 24;
       currentFigure.Children(3).YLabel.FontWeight = 'bold';
       currentFigure.Children(3).XTickLabelRotation = 90;
       currentFigure.Children(3).XLabel.FontSize = 24;
       currentFigure.Children(3).XLabel.FontWeight = 'bold';
       currentFigure.Children(3).Children(1).LineWidth = 1.5;
        
       currentFigure.Children(2).FontSize = 18;
       currentFigure.Children(2).XTickLabelRotation = 90;
       currentFigure.Children(2).XLabel.FontSize = 24;
       currentFigure.Children(2).XLabel.FontWeight = 'bold';
       currentFigure.Children(2).Children(1).LineWidth = 1.5;
        
       currentFigure.Children(1).FontSize = 18;
       currentFigure.Children(1).XTickLabelRotation = 90;
       currentFigure.Children(1).XLabel.FontSize = 24;
       currentFigure.Children(1).XLabel.FontWeight = 'bold';
       currentFigure.Children(1).Children(1).LineWidth = 1.5;
        
%       title(sprintf('Main Effects %s, %s, and %s for %s on collection %s', ...
%            EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name, ...
%            EXPERIMENT.measure.(measureID).fullName, EXPERIMENT.(trackID).name));

       currentFigure.PaperPositionMode = 'auto';
       currentFigure.PaperUnits = 'centimeters';
       currentFigure.PaperSize = [82 22];
       currentFigure.PaperPosition = [1 1 80 20];   

       figureID = EXPERIMENT.pattern.identifier.figure.mainEffects('tce', lugType, measureID, trackID);

       print(currentFigure, '-dpdf', EXPERIMENT.pattern.file.figure(trackID, figureID));

       close(currentFigure)
      
end

