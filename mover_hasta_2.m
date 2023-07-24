%% Inicializamos la primera posición (coordenadas x,y,z)
initpos=odom.LatestMessage.Pose.Pose.Position;

%% Bucle de control infinito
while (1)
    %% Obtenemos la posición actual
    pos=odom.LatestMessage.Pose.Pose.Position;
    %% Calculamos la distancia euclÃdea que se ha desplazado
    dist=sqrt((initpos.X-pos.X)^2+(initpos.Y-pos.Y)^2)
    msg2=receive(sonar3)
    if (msg2.Range_<=2) 
        msg.Linear.X=0;
        send(pub,msg);
        break;
    else
        send(pub,msg);
    end
    % Temporización del bucle según el parámetro establecido en r
    waitfor(r)
end