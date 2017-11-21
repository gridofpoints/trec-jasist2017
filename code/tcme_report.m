%% tcme_report
% 
% Prints the summary report and save it to a tex file for four factors, 
% mixed effects, repeated measures GLMM considering topics as random factor 
% (repeated measures/within-subject)  and system components and measures 
% as fixed factors.
%
%% Synopsis
%
%   [] = tcme_report(fid, anovaTable, soa)
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


function [] = tcme_report(fid, anovaTable, soa)

    % check the number of input arguments
    narginchk(3, 3);

    % the identifiers of the tracks at the first level fields in the
    % anovaTable (or soa) struct
    tracks = fields(anovaTable);

    % setup common parameters
    common_parameters;
                
    subTrackRows = 30;
    subLugRows = 10;
    
    % for each track
    for t = 1:length(tracks)
        
        trackID = tracks{t};
        trackName = EXPERIMENT.(trackID).name;
        
        printFirstRow = true;
        
        %fprintf(fid, '\\begin{landscape}  \n');
        fprintf(fid, '\\begin{table}[p] \n');
        % fprintf(fid, '\\tiny \n');
        fprintf(fid, '\\centering \n');
        % fprintf(fid, '\\vspace*{-12em} \n');
        %fprintf(fid, '\\hspace*{-6.5em} \n');
        
        fprintf(fid, '\\begin{tabular}{|l|l|l|r|} \n');
        
        fprintf(fid, '\\hline\\hline \n');
        
        fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Collection}} & \\multicolumn{1}{|c}{\\textbf{Lexical Units}} & \\multicolumn{2}{|c|}{\\textbf{Effects}} \\\\  \n');
        
        fprintf(fid, '\\hline \n');
        
        
        for lug = 1:EXPERIMENT.taxonomy.lug.number
                
                lugType = EXPERIMENT.taxonomy.lug.list{lug};                
                lugName = EXPERIMENT.taxonomy.(lugType).name;   
        
                if printFirstRow  % the header for the very first row of the table
                    fprintf(fid, ' \\multirow{%d}*{%s} & \\multirow{%d}*{%s} & $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', ...
                        subTrackRows, trackName , ...
                        subLugRows, lugName, ...
                        EXPERIMENT.taxonomy.stop.name);
                    
                    printFirstRow = false;
                else
                    fprintf(fid, '  & \\multirow{%d}*{%s} & $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', ...
                        subLugRows, lugName, ...
                        EXPERIMENT.taxonomy.stop.name);
                end;
                                
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n ');
                elseif anovaTable.(trackID).(lugType){3, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.stop < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop, ...
                                anovaTable.(trackID).(lugType){3, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.stop < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop, ...
                                anovaTable.(trackID).(lugType){3, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop, ...
                                anovaTable.(trackID).(lugType){3, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){3, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.stop, ...
                        anovaTable.(trackID).(lugType){3, 7} ...
                        );
                end;
                
                
                fprintf(fid, '             &        &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.(lugType).name);
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){4, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.stem < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem, ...
                                anovaTable.(trackID).(lugType){4, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.stem < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem, ...
                                anovaTable.(trackID).(lugType){4, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem, ...
                                anovaTable.(trackID).(lugType){4, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){4, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.stem, ...
                        anovaTable.(trackID).(lugType){4, 7} ...
                        );
                end;
                
                fprintf(fid, '             &        &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.model.name);
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){5, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.model < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.model, ...
                                anovaTable.(trackID).(lugType){5, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.model < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.model, ...
                                anovaTable.(trackID).(lugType){5, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.model, ...
                                anovaTable.(trackID).(lugType){5, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){5, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.model, ...
                        anovaTable.(trackID).(lugType){5, 7} ...
                        );
                end;
                
                fprintf(fid, '             &        &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', 'Measures');
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n ');
                elseif anovaTable.(trackID).(lugType){6, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.measure < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.measure, ...
                                anovaTable.(trackID).(lugType){6, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.measure < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.measure, ...
                                anovaTable.(trackID).(lugType){6, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.measure, ...
                                anovaTable.(trackID).(lugType){6, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){6, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.measure, ...
                        anovaTable.(trackID).(lugType){6, 7} ...
                        );
                end;
                
                fprintf(fid, '            &         &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name);
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){7, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.stop_stem < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_stem, ...
                                anovaTable.(trackID).(lugType){7, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.stop_stem < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_stem, ...
                                anovaTable.(trackID).(lugType){7, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_stem, ...
                                anovaTable.(trackID).(lugType){7, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){7, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.stop_stem, ...
                        anovaTable.(trackID).(lugType){7, 7} ...
                        );
                end;
                
                fprintf(fid, '            &         &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.model.name);
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){8, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.stop_model < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_model, ...
                                anovaTable.(trackID).(lugType){8, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.stop_model < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_model, ...
                                anovaTable.(trackID).(lugType){8, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_model, ...
                                anovaTable.(trackID).(lugType){8, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){8, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.stop_model, ...
                        anovaTable.(trackID).(lugType){8, 7} ...
                        );
                end;
                
                fprintf(fid, '            &         &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.stop.name, 'Measures');
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){9, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.stop_measure < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_measure, ...
                                anovaTable.(trackID).(lugType){9, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.stop_measure < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_measure, ...
                                anovaTable.(trackID).(lugType){9, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stop_measure, ...
                                anovaTable.(trackID).(lugType){9, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){9, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.stop_measure, ...
                        anovaTable.(trackID).(lugType){9, 7} ...
                        );
                end;
                
                fprintf(fid, '           &          &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name);
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){10, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.stem_model < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem_model, ...
                                anovaTable.(trackID).(lugType){10, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.stem_model < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem_model, ...
                                anovaTable.(trackID).(lugType){10, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem_model, ...
                                anovaTable.(trackID).(lugType){10, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){10, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.stem_model, ...
                        anovaTable.(trackID).(lugType){10, 7} ...
                        );
                end;
                
                fprintf(fid, '           &          &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.(lugType).name, 'Measures');
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){11, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.stem_measure < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem_measure, ...
                                anovaTable.(trackID).(lugType){11, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.stem_measure < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem_measure, ...
                                anovaTable.(trackID).(lugType){11, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.stem_measure, ...
                                anovaTable.(trackID).(lugType){11, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){11, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.stem_measure, ...
                        anovaTable.(trackID).(lugType){11, 7} ...
                        );
                end;
                
                fprintf(fid, '           &          &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.model.name, 'Measures');
                if isempty(anovaTable.(trackID).(lugType))
                        fprintf(fid, ' & -- (--) \\\\ \n');
                elseif anovaTable.(trackID).(lugType){12, 7} <= EXPERIMENT.analysis.alpha
                        if soa.(trackID).(lugType).omega2p.model_measure < EXPERIMENT.analysis.smallEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.smallEffect.color, ...
                                soa.(trackID).(lugType).omega2p.model_measure, ...
                                anovaTable.(trackID).(lugType){12, 7} ...
                                );
                        elseif soa.(trackID).(lugType).omega2p.model_measure < EXPERIMENT.analysis.mediumEffect.threshold
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.mediumEffect.color, ...
                                soa.(trackID).(lugType).omega2p.model_measure, ...
                                anovaTable.(trackID).(lugType){12, 7} ...
                                );
                        else
                            fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n ', ...
                                EXPERIMENT.analysis.largeEffect.color, ...
                                soa.(trackID).(lugType).omega2p.model_measure, ...
                                anovaTable.(trackID).(lugType){12, 7} ...
                                );
                        end;                        
                elseif anovaTable.(trackID).(lugType){12, 7} > EXPERIMENT.analysis.alpha
                    fprintf(fid, ' & \\cellcolor{%s} %.4f (%.2f) \\\\ \n', ...
                        EXPERIMENT.analysis.notSignificantColor, ...
                        soa.(trackID).(lugType).omega2p.model_measure, ...
                        anovaTable.(trackID).(lugType){12, 7} ...
                        );
                end;
                
               
                
                fprintf(fid, '\\cline{2-4} \n');
                
        end;
        
        fprintf(fid, '\\hline \n');
        
        fprintf(fid, '\\hline \n');
        
        fprintf(fid, '\\end{tabular} \n');
        
        fprintf(fid, '\\caption{Summary of four %s on %s. Each cell reports the estimated $\\omega^2$ SoA for the speficied effects and, within parentheses, the p-value for those effects.} \n', ...
            EXPERIMENT.analysis.tcme.name, trackName);
        
        fprintf(fid, '\\label{tab:tcme-summary-%s} \n', trackID);
        
        fprintf(fid, '\\end{table} \n\n');
        
        %fprintf(fid, '\\end{landscape}  \n');

        
    end; % track
            
    diary off;

end