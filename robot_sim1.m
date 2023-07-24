function [] = pract_2P_robot(x,y)
%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
rosshutdown
setenv('ROS_MASTER_URI','http://172.29.30.175:11311');
setenv('ROS_IP','172.29.29.54');
rosinit() % Inicialización de ROS en la IP correspondiente
%% Habilitar los motores
%publisher
pub_enable = rospublisher('/cmd_motor_state','std_msgs/Int32');
%declaración mensaje
msg_enable_motor = rosmessage(pub_enable);
%activar motores enviando enable_motor = 1
msg_enable_motor.Data = 1;
send(pub_enable,msg_enable_motor);

%% DECLARACIÓN DE VARIABLES NECESARIAS PARA EL CONTROL
x = 5;
y = 5;
Ked = 1;
Keo = 1;
%% DECLARACIÓN DE SUBSCRIBERS
odom = rossubscriber('pose'); % Subscripción a la odometría

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)

%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(10);
waitfor(r);
pause(1);

%% Nos aseguramos recibir un mensaje relacionado con el robot
while (strcmp(odom.LatestMessage.ChildFrameId,'base_link')~=1)
    odom.LatestMessage
end
%% Obtenemos la posición y orientación INICIAL
pos_ini=odom.LatestMessage.Pose.Pose.Position;
ori_ini=odom.LatestMessage.Pose.Pose.Orientation;
yaw_ini=quat2eul([ori_ini.W ori_ini.X ori_ini.Y ori_ini.Z]);
yaw_ini=yaw_ini(1);

%Actualizamos el destino a posición relativa a donde esta el robot en el momento inicial de ejecutar este script.
x_goal_new = (pos_ini.X + x*cos(yaw_ini) - y*sin(yaw_ini));
y_goal_new = (pos_ini.Y + x*sin(yaw_ini) + y*cos(yaw_ini));

%% Umbrales para condiciones de parada del robot
umbral_distancia = 0.1;
umbral_angulo = 0.1;
%% Bucle de control infinito
while (1)

%% Obtenemos la posición y orientación actuales
pos=odom.LatestMessage.Pose.Pose.Position;
ori=odom.LatestMessage.Pose.Pose.Orientation;
yaw=quat2eul([ori.W ori.X ori.Y ori.Z]);
yaw=yaw(1);
%% Calculamos el error de distancia
Edist = sqrt((pos.X-x_goal_new)^2+(pos.Y-y_goal_new)^2);
%% Calculamos el error de orientación
Eori = atan2(y_goal_new-pos.Y,x_goal_new-pos.X)- yaw;

%% Calculamos las consignas de velocidades

consigna_vel_linear = Ked * Edist;
consigna_vel_ang = Keo * Eori;

%% Condición de parada
disp("Edist =" + Edist)
disp("Eori =" + Eori)
if (Edist<umbral_distancia) && (abs(Eori)<umbral_angulo)
    msg_vel.Linear.X= 0;
    msg_vel.Linear.Y=0;
    msg_vel.Linear.Z=0;
    msg_vel.Angular.X=0;
    msg_vel.Angular.Y=0;
    msg_vel.Angular.Z=0;
    send(pub,msg_vel)
    break;
end
%% Aplicamos consignas de control
msg_vel.Linear.X= consigna_vel_linear;
msg_vel.Linear.Y=0;
msg_vel.Linear.Z=0;
msg_vel.Angular.X=0;
msg_vel.Angular.Y=0;
msg_vel.Angular.Z= consigna_vel_ang;
% Comando de velocidad
send(pub,msg_vel);
% Temporización del bucle según el parámetro establecido en r
waitfor(r);
end
%% DESCONEXIÓN DE ROS
rosshutdown;
end
