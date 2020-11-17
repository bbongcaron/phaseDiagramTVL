function [] = phaseDiagramT_XY(comp1, comp2, P)
% pressure in mmHg, temperature in C
    components = readvars('antoinesCoefficients.xlsx', 'Range', 'A2:A147');
    [matA, matB, matC] = readvars('antoinesCoefficients.xlsx', 'Range', 'B2:D147');
    A1 = 0; B1 = 0; C1 = 0;
    A2 = 0; B2 = 0; C2 = 0;
    found1 = false; found2 = false;
    numPts = 100;
    liqFract1 = zeros(1, numPts); liqFract2 = zeros(1, numPts)
    vapFract1 = zeros(1, numPts); vapFract2 = zeros(1, numPts);
    % linear search for components O(n), where n is number of components
    % in excel spreadsheet
    for i = 1:length(components)
        if ~found1 && strcmp(lower(comp1),lower(components(i)))
            A1 = matA(i);
            B1 = matB(i);
            C1 = matC(i);
            found1 = true;
        end 
        if ~found2 && strcmp(lower(comp2),lower(components(i)))
            A2 = matA(i);
            B2 = matB(i);
            C2 = matC(i);
            found2 = true;
        end
    end
    if ~found1 || ~found2
        if ~found1
            disp("Component 1 not found.");
        end
        if ~found2
            disp("Component 2 not found.");
        end
        disp("Quitting program...");
        return;
    end
    tSat1 = (B1 / (A1 - log10(P))) - C1;
    tSat2 = (B2 / (A2 - log10(P))) - C2;
    temps = linspace(tSat1, tSat2, numPts);
    for i = 1:numPts
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
    end
end