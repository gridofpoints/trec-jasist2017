%% tce_plot_interactionEffects
% 
% Produces the interaction effects plot for a three factors, mixed effects, 
% repeated measures GLMM considering topics as random factor 
% (repeated measures/within-subject) and system components as fixed factors.

%% Synopsis
%
%   [] = tce_plot_interactionEffects(measures, measureID, trackID, lugType)
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

function [] = tce_plot_interactionEffects(measures, measureID, trackID, lugType)

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
    
       interactionplot(data, {factorA, factorB, factorC}, ...
            'VarNames', {EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name});
        
        
       % turn off the automatically generated legends 
       %currentFigure.Children(1).Visible = 'off';
       currentFigure.Children(1).Position = [0.7351    0.8053    0.1560    0.1016];
       %currentFigure.Children(6).Visible = 'off';
       currentFigure.Children(6).Position = [0.7351    0.5409    0.1866    0.1016];
       %currentFigure.Children(11).Visible = 'off';
       currentFigure.Children(11).Position = [0.7351    0.0942    0.1680    0.2765];

       % rotate the IR models labels
       currentFigure.Children(4).FontSize = 30;
       currentFigure.Children(4).XTickLabelRotation = 90;
       
       % rotate the stop labels
       currentFigure.Children(9).FontSize = 30;
       currentFigure.Children(9).XTickLabelRotation = 90;
       
       % rotate the lugType labels
       currentFigure.Children(3).FontSize = 30;
       currentFigure.Children(3).XTickLabelRotation = 90;
       
       currentFigure.Children(10).FontSize = 30;
       currentFigure.Children(10).XTickLabelRotation = 90;
       
       %enlarge labels
       currentFigure.Children(5).FontSize = 30;
       currentFigure.Children(8).FontSize = 30;
       
       % set the size and weight for the Stop Lists title
       currentFigure.Children(2).Children(1).FontSize = 48;
       currentFigure.Children(2).Children(1).FontWeight = 'bold';
                
       % set the size and weight for the LugType title
       currentFigure.Children(7).Children(1).FontSize = 48;
       currentFigure.Children(7).Children(1).FontWeight = 'bold';
                       
       % set the size and weight for the IR Models title
       currentFigure.Children(12).Children(1).FontSize = 48;
       currentFigure.Children(12).Children(1).FontWeight = 'bold';
       
        
       %stops = currentFigure.Children(4).Children;
       %lugs = currentFigure.Children(5).Children;
       %models = currentFigure.Children(9).Children;
        
       % add a legend for the stop lists
       %l = legend(stops, EXPERIMENT.taxonomy.stop.id(end:-1:1));
       %l.Position = [0.1720 0.6688 0.0835 0.1560];
       %l.FontSize = 12;
       
       % add a legend for the lugs
       %l = legend(lugs, EXPERIMENT.taxonomy.(lugType).id(end:-1:1));
       %l.Position = [0.2884 0.3667 0.2312 0.2750];
       %l.FontSize = 12;
       
       % add a legend for the IR models
       %l = legend(models, EXPERIMENT.taxonomy.model.id(end:-1:1));
       %l.Position = [0.5098 -0.7833 0.3116 1.1417];
       %l.FontSize = 12;
        
       %title(sprintf('Interaction Effects %s, %s, and %s for %s on collection %s', ...
       %     EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name, ...
       %     EXPERIMENT.measure.(measureID).fullName, EXPERIMENT.(trackID).name));

      % ylabel('AP Correlation Marginal Mean', 'FontSize', 36, 'FontWeight', 'bold');
                        
       currentFigure.PaperPositionMode = 'auto';
       currentFigure.PaperUnits = 'centimeters';
       currentFigure.PaperSize = [162 82];
       currentFigure.PaperPosition = [1 1 160 80];

       figureID = EXPERIMENT.pattern.identifier.figure.interactionEffects('tce', lugType, measureID, trackID);

       print(currentFigure, '-dpdf', EXPERIMENT.pattern.file.figure(trackID, figureID));

       close(currentFigure)
      
end

