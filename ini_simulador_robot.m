%% DECLARACIÓN DE SUBSCRIBERS
odom=rossubscriber('pose'); % Subscripción a la odometría
laser = rossubscriber('/scan', rostype.sensor_msgs_LaserScan);
sonar0= rossubscriber('/sonar_0', rostype.sensor_msgs_Range);
sonar1= rossubscriber('/sonar_1', rostype.sensor_msgs_Range);
sonar2= rossubscriber('/sonar_2', rostype.sensor_msgs_Range);
sonar3= rossubscriber('/sonar_3', rostype.sensor_msgs_Range);
sonar4= rossubscriber('/sonar_4', rostype.sensor_msgs_Range);
sonar5= rossubscriber('/sonar_5', rostype.sensor_msgs_Range);
sonar6= rossubscriber('/sonar_6', rostype.sensor_msgs_Range);
sonar7= rossubscriber('/sonar_7', rostype.sensor_msgs_Range);
%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist'); %
%% GENERACIÓN DE MENSAJE
msg=rosmessage(pub) %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)
msg_laser=rosmessage(laser)
msg_sonar0=rosmessage(sonar0)
msg_sonar1=rosmessage(sonar1)
msg_sonar2=rosmessage(sonar2)
msg_sonar3=rosmessage(sonar3)
msg_sonar4=rosmessage(sonar4)
msg_sonar5=rosmessage(sonar5)
msg_sonar6=rosmessage(sonar6)
msg_sonar7=rosmessage(sonar7)
% Rellenamos los campos del mensaje para que el robot avance a 0.2 m/s

% Velocidades lineales en x,y y z (velocidades en y o z no se usan en robots diferenciales y entornos 2D)
msg.Linear.X=0;
msg.Linear.Y=0;
msg.Linear.Z=0;
% Velocidades angulares (en robots diferenciales y entornos 2D solo se utilizará el valor Z)
msg.Angular.X=0;
msg.Angular.Y=0;
msg.Angular.Z=0;

%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(10);
%% Nos aseguramos recibir un mensaje relacionado con el robot "robot0" pause(1); % Esperamos 1 segundo para asegurarnos que ha llegado algún mensaje odom, porque sino ls función strcmp da error al tener uno de los campos vacios.
pause(5)

while (strcmp(odom.LatestMessage.ChildFrameId,'base_link')~=1)
    odom.LatestMessage
end
