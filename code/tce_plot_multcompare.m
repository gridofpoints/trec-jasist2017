%% tce_plot_multcompare
% 
% Produces the Tukey HSD multiple comparison plots for a three factors, 
% mixed effects, repeated measures GLMM considering topics as random factor 
% (repeated measures/within-subject) and system components as fixed factors.

%% Synopsis
%
%   [] = tce_plot_multcompare(anovaStats, measureID, trackID, lugType)
%  
% *Parameters*
%
% * *|anovaStats|* - a set of ANOVA statistics. 
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

function [] = tce_plot_multcompare(anovaStats, measureID, trackID, lugType)

    % check the number of input parameters
    narginchk(4, 4);

    % load common parameters
    common_parameters


    % check that measures is a non-empty table
    validateattributes(anovaStats, {'struct'}, {'nonempty'}, '', 'anovaStats', 1);
    
    % check that measureID is a non-empty string
    validateattributes(measureID, {'char', 'cell'}, {'nonempty', 'vector'}, '', 'measureID');
    
    if iscell(measureID)
        % check that measureShortName is a cell array of strings with one element
        assert(iscellstr(measureID) && numel(measureID) == 1, ...
            'MATTERS:IllegalArgument', 'Expected measureID to be a cell array of strings containing just one string.');
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
        
    % stop lists
    currentFigure = figure('Visible', 'off');
    
       [~, d, ~, ~] = multcompare(anovaStats,'ctype', 'hsd', 'Dimension', [2], 'alpha', 0.05, 'display','on');
        

       currentFigure.Children.TickLabelInterpreter = 'none';
       currentFigure.Children.FontSize = 18;
        
       currentFigure.Children.Title.String = '';
        
       currentFigure.Children.XLabel.String = sprintf('%s Marginal Mean', EXPERIMENT.measure.(measureID).shortName);
       currentFigure.Children.XLabel.FontSize = 24;
       currentFigure.Children.XLabel.FontWeight = 'bold';
        
       currentFigure.Children.YLabel.String = EXPERIMENT.taxonomy.stop.name;
       currentFigure.Children.YLabel.FontSize = 24;
       currentFigure.Children.YLabel.FontWeight = 'bold';
        
       currentFigure.Children.YTickLabel = strrep(currentFigure.Children.YTickLabel, [EXPERIMENT.taxonomy.stop.name '='], '');

       highlightTopGroup(currentFigure, d, true, EXPERIMENT.taxonomy.stop.number);
    
       currentFigure.PaperPositionMode = 'auto';
       currentFigure.PaperUnits = 'centimeters';
       currentFigure.PaperSize = [22 32];
       currentFigure.PaperPosition = [1 1 20 30]; 
              
       figureID = EXPERIMENT.pattern.identifier.figure.multcompare('tce', lugType, 'stop', measureID, trackID);

       print(currentFigure, '-dpdf', EXPERIMENT.pattern.file.figure(trackID, figureID));

       close(currentFigure)
       
    % lugs
    currentFigure = figure('Visible', 'off');
    
       [~, d, ~, ~] = multcompare(anovaStats,'ctype', 'hsd', 'Dimension', [3], 'alpha', 0.05, 'display','on');
        

       currentFigure.Children.TickLabelInterpreter = 'none';
       currentFigure.Children.FontSize = 18;
        
       currentFigure.Children.Title.String = '';
        
       currentFigure.Children.XLabel.String = sprintf('%s Marginal Mean', EXPERIMENT.measure.(measureID).shortName);
       currentFigure.Children.XLabel.FontSize = 24;
       currentFigure.Children.XLabel.FontWeight = 'bold';
        
       currentFigure.Children.YLabel.String = EXPERIMENT.taxonomy.(lugType).name;
       currentFigure.Children.YLabel.FontSize = 24;
       currentFigure.Children.YLabel.FontWeight = 'bold';
        
       currentFigure.Children.YTickLabel = strrep(currentFigure.Children.YTickLabel, [EXPERIMENT.taxonomy.(lugType).name '='], '');

       highlightTopGroup(currentFigure, d, true, EXPERIMENT.taxonomy.(lugType).number);
    
       currentFigure.PaperPositionMode = 'auto';
       currentFigure.PaperUnits = 'centimeters';
       currentFigure.PaperSize = [22 32];
       currentFigure.PaperPosition = [1 1 20 30]; 
              
       figureID = EXPERIMENT.pattern.identifier.figure.multcompare('tce', lugType, lugType, measureID, trackID);

       print(currentFigure, '-dpdf', EXPERIMENT.pattern.file.figure(trackID, figureID));

       close(currentFigure)
       
    % IR models
    currentFigure = figure('Visible', 'off');
    
       [~, d, ~, ~] = multcompare(anovaStats,'ctype', 'hsd', 'Dimension', [4], 'alpha', 0.05, 'display','on');
        

       currentFigure.Children.TickLabelInterpreter = 'none';
       currentFigure.Children.FontSize = 18;
        
       currentFigure.Children.Title.String = '';
        
       currentFigure.Children.XLabel.String = sprintf('%s Marginal Mean', EXPERIMENT.measure.(measureID).shortName);
       currentFigure.Children.XLabel.FontSize = 24;
       currentFigure.Children.XLabel.FontWeight = 'bold';
        
       currentFigure.Children.YLabel.String = EXPERIMENT.taxonomy.model.name;
       currentFigure.Children.YLabel.FontSize = 24;
       currentFigure.Children.YLabel.FontWeight = 'bold';
        
       currentFigure.Children.YTickLabel = strrep(currentFigure.Children.YTickLabel, [EXPERIMENT.taxonomy.model.name '='], '');

       highlightTopGroup(currentFigure, d, true, EXPERIMENT.taxonomy.model.number);
    
       currentFigure.PaperPositionMode = 'auto';
       currentFigure.PaperUnits = 'centimeters';
       currentFigure.PaperSize = [22 32];
       currentFigure.PaperPosition = [1 1 20 30]; 
              
       figureID = EXPERIMENT.pattern.identifier.figure.multcompare('tce', lugType, 'model', measureID, trackID);

       print(currentFigure, '-dpdf', EXPERIMENT.pattern.file.figure(trackID, figureID));

       close(currentFigure)
      
end


function [] =  highlightTopGroup(h, m, usemax, cmpNum)

    common_parameters;
    
    % the index of the top element in the top group
    if usemax
        [~, topElement] = max(m(:, 1));
    else
        [~, topElement] = min(m(:, 1));
    end;
    
    % Get bounds for the top group
    topGroupHandle = findobj(h, 'UserData', -topElement);
    if (isempty(topGroupHandle))
        return; 
    end % unexpected

    topGroupX = get(topGroupHandle, 'XData');
    topGroupLower = min(topGroupX);
    topGroupUpper = max(topGroupX);
    
    % Change the comparison lines to use these values
    comparisonLines = findobj(h, 'UserData', 'Comparison lines');
    if (~isempty(comparisonLines))
       comparisonLines.LineWidth = 2;
       comparisonLines.XData(1:2) = topGroupLower;
       comparisonLines.XData(4:5) = topGroupUpper;
    end

    % arrange line styles and markers
    for e=1:cmpNum

        % look for the line and marker of the current element
        lineHandle = findobj(h, 'UserData', -e, 'Type','Line', '-and', 'LineStyle', '-', '-and', 'Marker', 'none');
        markerHandle = findobj(h, 'UserData', e, 'Type','Line', '-and', 'LineStyle', 'none', '-and', 'Marker', 'o');

        if (isempty(lineHandle))
            continue;
        end  % unexpected

        currentElementX = get(lineHandle, 'XData');
        currentElementLower = min(currentElementX);
        currentElementUpper = max(currentElementX);
        
        % To be in the top group the upper bound of the current element
        % (CEL) must be above the lower bound of the top group (TGL) and
        % the lower bound of the current element (CEL) must be below the
        % upper bound of the top groud (TGL)
        %
        %  CEL    TGL   CEU  TGU
        %   |      |_____|____|
        %   |____________|
        %
        %  TGL   CEL  TGU     CEU
        %   |_____|____|       |
        %         |____________|
        %
        if ( currentElementUpper > topGroupLower && currentElementLower < topGroupUpper)
            lineHandle.Color = 'b';
            lineHandle.LineWidth = 2.5;
            lineHandle.Visible = 'on';
            markerHandle.MarkerFaceColor = 'b';
            markerHandle.MarkerEdgeColor = 'b';
            markerHandle.MarkerSize = 10;
        else
            lineHandle.Color = 'k';
            lineHandle.LineWidth = 1.5;
            lineHandle.Visible = 'on';
            markerHandle.MarkerFaceColor = 'k';
            markerHandle.MarkerEdgeColor = 'k';
            markerHandle.MarkerSize = 6;
        end;
        
    end; % for tags

 
end




