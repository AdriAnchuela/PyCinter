

    med_laser=receive(laser)
    %Distancia
    ParedN = 1;
    ParedS = 1;
    ParedE = 1;
    ParedO = 1;
   
    
    % Distancia de dos metros a la pared
    if med_laser.Ranges(90) > 1.4
        ParedO = 0;
    end
    if med_laser.Ranges(360) > 1.4
        ParedN = 0;
    end
    if med_laser.Ranges(270) > 1.4
        ParedE = 0;
    end
    if med_laser.Ranges(180) > 1.4
        ParedS = 0;
    end
    
    if ParedN == 0
        if ParedO == 0
            if ParedS == 0
                if ParedE == 0
                    Tipo = 0;
                end
            end
        end
    end
    
    if ParedN == 1
        if ParedO == 1
            if ParedS == 0
                if ParedE == 1
                    Tipo = 2;
                end
            end
        end
    end    