function [] = phaseDiagramT_XY(comp1, comp2, P)
    components = readvars('antoinesCoefficients.xlsx', 'Range', 'A2:A147');
    [matA, matB, matC] = readvars('antoinesCoefficients.xlsx', 'Range', 'B2:D147');
    A1 = 0; B1 = 0; C1 = 0;
    A2 = 0; B2 = 0; C2 = 0;
    found1 = false; found2 = false;
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
end