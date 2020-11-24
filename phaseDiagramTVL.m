function [] = phaseDiagramTVL()
%% (0) Request user input through GUI
   [comp1, comp2, P] = userInput();
%% (1) Initialize variables and arrays
    components = readvars('antoinesCoefficients.xlsx', 'Range', 'A2:A147');
    [matA, matB, matC, matLowTemp, matHighTemp] = ...
        readvars('antoinesCoefficients.xlsx', 'Range', 'B2:F147');
    A1 = 0; B1 = 0; C1 = 0; lowTemp1 = 0; highTemp1 = 0;
    A2 = 0; B2 = 0; C2 = 0; lowTemp2 = 0; highTemp2 = 0;
    found1 = false; found2 = false;
    numPts = 100;
    liqFract1 = zeros(1, numPts); liqFract2 = zeros(1, numPts);
    vapFract1 = zeros(1, numPts); vapFract2 = zeros(1, numPts);
%% (2) Linear search for comp1 and comp2
    for i = 1:length(components)
        if ~found1 && strcmpi(comp1,components(i))
            A1 = matA(i);
            B1 = matB(i);
            C1 = matC(i);
            lowTemp1 = matLowTemp(i);
            highTemp1 = matHighTemp(i);
            found1 = true;
        end 
        if ~found2 && strcmpi(comp2,components(i))
            A2 = matA(i);
            B2 = matB(i);
            C2 = matC(i);
            lowTemp2 = matLowTemp(i);
            highTemp2 = matHighTemp(i);
            found2 = true;
        end
        if found1 && found2
            break
        end
    end
 %% (3) Calculation of saturation temperature @P (user-input)
    tSat1 = (B1 / (A1 - log10(P))) - C1;
    tSat2 = (B2 / (A2 - log10(P))) - C2;
 %% (4) Calculation of vapor/liquid fractions @each linearly spaced temp.
    temps = linspace(tSat1, tSat2, numPts);
    i = 1;
    while i <= numPts
        if temps(i) < lowTemp1 || temps(i) < lowTemp2 ...
                || temps(i) > highTemp1 || temps(i) > highTemp2
            if length(i) == 1
                temps = realmin;
                numPts = numPts - 1;
            else
                temps(i) = [];
                liqFract1(i) = [];
                liqFract2(i) = [];
                vapFract1(i) = [];
                vapFract2(i) = [];
                numPts = numPts - 1;
            end
        else
            currentTemp = temps(i);
            % calculation of saturation pressure at a given currentTemp
            pSat1 = 10^(A1 - (B1 / (currentTemp + C1)));
            pSat2 = 10^(A2 - (B2 / (currentTemp + C2)));
            % Rearrangement of bubble point pressure eq to solve for liquid
            % mole fraction
            liqFract1(i) = (P - pSat2) / (pSat1 - pSat2);
            liqFract2(i) = 1 - liqFract1(i);
            % Rearrangement of Raoult's Law to solve for vapor mole fraction
            vapFract1(i) = (liqFract1(i)*pSat1) / P;
            vapFract2(i) = 1 - vapFract1(i);
            i = i + 1;
        end
    end
 %% (5) Creation of phase diagram
    if temps == realmin
        msgbox("There are no valid temperatures at which " + comp1 ...
            + " and " + comp2 + " both obey Raoult's Law.", ...
            "No possible phase diagram describing real behavior!")
    else
        figure('Name', "T vs. XY Phase Diagram of a " + comp1 + " + " + ...
            comp2 + " mixture @P = " + P + " mmHg")
        plot(liqFract1, temps)
        hold on
        plot(vapFract1, temps)
        title("T vs. XY Phase Diagram of a " + comp1 + " + " + ...
            comp2 + " mixture @P = " + P + " mmHg")
        ylabel('Temperature T [°C]')
        xlabel("x " + comp1 + ", y " + comp1 + " [mol/mol]")
        xlim([0, 1])
        ylim([min(tSat1, tSat2) - 5, max(tSat1, tSat2) + 5])
        grid on
        grid minor
    end
    return;
end

function [comp1, comp2, P] = userInput()
    % may be inefficient run-time wise to grab component column twice, 
    % however big O is still O(n), where
    % n is number of components in heatCapacity.xlsx
    matComp = readvars('antoinesCoefficients.xlsx', 'Range', 'A2:A147');
    len = length(matComp);
    i = 1;
    %% remove duplicate names
    while i < len
        if strcmpi(matComp(i), matComp(i+1))
            matComp(i+1) = [];
            len = len - 1;
        end
        i = i + 1;
    end
    %% Listdlg to choose component
    comp1Index = listdlg('ListString', matComp, ...
        'PromptString', 'Select Component 1:', ...
        'ListSize', [400,400], 'SelectionMode', 'single');
    comp1 = matComp{comp1Index}
    comp2Index = listdlg('ListString', matComp, ...
        'PromptString', 'Select Component 2:', ...
        'ListSize', [400,400], 'SelectionMode', 'single');
    comp2 = matComp{comp2Index}
    pressureCell = inputdlg({'Pressure [mmHg]'}, 'Pressure Input', [1 50]);
    P = str2double(pressureCell{1});
end