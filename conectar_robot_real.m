%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.

setenv('ROS_MASTER_URI','http://172.29.30.177:11311')
setenv('ROS_IP','172.29.29.59')

rosinit % Inicialización de ROS

%% Habilitar los motores
%publisher
pub_enable = rospublisher('/cmd_motor_state','std_msgs/Int32');
%declaración mensaje
msg_enable_motor = rosmessage(pub_enable);
%activar motores enviando enable_motor = 1
msg_enable_motor.Data = 1;
send(pub_enable,msg_enable_motor);