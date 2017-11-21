%% tse_report
% 
% Prints the summary report and save it to a tex file for single factor, 
% mixed crossed effects, repeated measures GLMM considering topics as 
% random factor (repeated measures/within-subject) and systems as fixed 
% factor.
%
%% Synopsis
%
%   [] = tse_report(fid, anovaTable, soa)
%  
%
% *Parameters*
%
% * *|fid|* - the file where to print.
% * *|anovaTable|* - a struct containing the ANOVA table of the different
% tracks.
% * *|soa|* - a struct containing the SoA of the different tracks.
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
% * *Requirements*: MATTERS 1.0 or higher; Matlab 2015b or higher
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


function [] = tse_report(fid, anovaTable, soa)
  
    % check the number of input arguments
    narginchk(3, 3);

    % the identifiers of the tracks at the first level fields in the
    % anovaTable (or soa) struct
    tracks = fields(anovaTable);
     
    % setup common parameters
    common_parameters;
        
    
    fprintf(fid, '\\begin{landscape}  \n');
    fprintf(fid, '\\begin{table}[p] \n');
    % fprintf(fid, '\\tiny \n');
    fprintf(fid, '\\centering \n');
    fprintf(fid, '\\hspace*{-6.5em} \n');
    
    fprintf(fid, '\\begin{tabular}{|l|l|l|*{%d}{r|}} \n', EXPERIMENT.measure.number);
    
    fprintf(fid, '\\hline\\hline \n');
    
    fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Collection}} & \\multicolumn{1}{|c}{\\textbf{Lexical Units}} & \\multicolumn{1}{|c}{\\textbf{Effects}} ');      
    for m = 1:EXPERIMENT.measure.number
        if m == EXPERIMENT.measure.number
            fprintf(fid, '& \\multicolumn{1}{|c|}{\\textbf{%s}} ', EXPERIMENT.measure.list{m});
        else
            fprintf(fid, '& \\multicolumn{1}{|c}{\\textbf{%s}} ', EXPERIMENT.measure.list{m});
        end;
    end; % measure
    fprintf(fid, '\\\\ \n');
    
    fprintf(fid, '\\hline \n');  
    
    % for each track
    for t = 1:length(tracks)
        
        trackID = tracks{t};
        
        for lug = 1:EXPERIMENT.taxonomy.lug.number
            lugType = EXPERIMENT.taxonomy.lug.list{lug};
            
            if lug == 1
                fprintf(fid, ' \\multirow{3}*{%s} & %s &  $\\hat{\\omega}^2_{\\langle\\text{Systems}\\rangle}$ ', ...
                    EXPERIMENT.(trackID).name, ...
                    EXPERIMENT.taxonomy.(lugType).name);
            else
                fprintf(fid, '                     & %s &  $\\hat{\\omega}^2_{\\langle\\text{Systems}\\rangle}$ ', ...
                    EXPERIMENT.taxonomy.(lugType).name);
            end;
            
            for m = 1:EXPERIMENT.measure.number
                measureID = EXPERIMENT.measure.list{m};
                
                if isempty(anovaTable.(trackID).(measureID).(lugType))
                    fprintf(fid, ' & -- (--) ');
                elseif anovaTable.(trackID).(measureID).(lugType){3, 7} <= EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & %.4f (%.4f) ', soa.(trackID).(measureID).(lugType).omega2p.systems, anovaTable.(trackID).(measureID).(lugType){3, 7});
                elseif anovaTable.(trackID).(measureID).(lugType){3, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(measureID).(lugType).omega2p.systems, anovaTable.(trackID).(measureID).(lugType){3, 7});
                end;
                
            end; % measure
            fprintf(fid, '\\\\ \n');
            
        end; % lugType
        
        fprintf(fid, '\\hline \n');
        
    end; % track
        
    fprintf(fid, '\\hline \n');
    
    fprintf(fid, '\\end{tabular} \n');
    
    fprintf(fid, '\\caption{Summary of %s. Each cell reports the estimated $\\hat{\\omega}^2$ SoA for the System effects and, within parentheses, the p-value for those effects.}\n', ...
        EXPERIMENT.analysis.tse.name);
    
    fprintf(fid, '\\label{tab:tse-summary} \n');
    
    fprintf(fid, '\\end{table} \n\n');
    
    fprintf(fid, '\\end{landscape}  \n');
    
    
end
