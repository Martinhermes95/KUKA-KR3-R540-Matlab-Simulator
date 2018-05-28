-%% Trabalho de robótica - André e Martin

clc
clear all
close all

%% Simulação do robô:

L1 = Link('d', -345, 'a', -20, 'alpha',-pi/2, 'qlim',[-170*pi/180 +170*pi/180]);
L2 = Link('d', 0, 'a', 260, 'alpha', 0,'offset', pi/2, 'qlim',[-170*pi/180 +50*pi/180]);
L3 = Link('d', 0, 'a', 20, 'alpha', pi/2,'qlim',[-110*pi/180 +155*pi/180]);
L4 = Link('d', -260, 'a', 0, 'alpha', -pi/2, 'qlim',[-175*pi/180 +175*pi/180]);
L5 = Link('d', 0, 'a', 0, 'alpha', pi/2, 'qlim',[-120*pi/180 +120*pi/180]);
L6 = Link('d', -195.32, 'a', 0, 'alpha', 0, 'qlim',[-350*pi/180 +350*pi/180]);

L = [L1;L2;L3;L4;L5;L6];
robo = SerialLink(L, 'name', 'KUKA KR3 R540');

Q=[0 0 0 0 0 0];

robo.plot(Q, 'notiles', 'floorlevel', 200, 'lightpos',[0 0 0])
robo.teach(Q)

set(gca,'Ydir','reverse')
set(gca,'Zdir','reverse')
%% Ângulos para teste:

A1 = -pi/3;
A2 = -pi/23;
A3 = -pi/4;
A4 = pi/4;
A5 = pi/4;
A6 = pi/4;

%% Cinemática direta:

Dh = [A1 -345 -20 -pi/2; A2+pi/2 0 260 0; A3 0 20 pi/2; A4 -260 0 -pi/2; A5 0 0 pi/2; A6 -195.32 0 0];  %Parâmetros de Denavit-Hartenberg

cm = 1;  %Colunas da matriz M (24)

for j = 1:6   %6 linhas da matriz contendo os parametros de DH
    P = [cos(Dh(j,1)) -sin(Dh(j,1))*cos(Dh(j,4)) sin(Dh(j,1))*sin(Dh(j,4)) Dh(j,3)*cos(Dh(j,1)); sin(Dh(j,1)) cos(Dh(j,1))*cos(Dh(j,4)) -cos(Dh(j,1))*sin(Dh(j,4)) Dh(j,3)*sin(Dh(j,1)); 0 sin(Dh(j,4)) cos(Dh(j,4)) Dh(j,2); 0 0 0 1];
    for c = 1:4
        for l = 1:4
        M(l,cm) = P(l,c); % Vetor com as 6 as matrizes de transformação
        end
        cm = cm+1;
    end
end

% Matrizes de transformação

T1 = M(1:4,1:4);  %T01
T2 = M(1:4,5:8);  %T12
T3 = M(1:4,9:12);  %T23
T4 = M(1:4,13:16);  %T34
T5 = M(1:4,17:20);  %T45
T6 = M(1:4,21:24);  %T56
 
T06 = T1*T2*T3*T4*T5*T6;  %Matriz de transformação da origem 0 até 6
 
%% Cinemática inversa:

O6 = T06(1:3,4);
R = T06(1:3,1:3);
d6=[0; 0; 195];

Ow = O6+R*d6;  %Posição do centro do punho
 
q1 = atan2(-Ow(2,1),-Ow(1,1));  %Ângulo A1
 
O4 = sqrt(Ow(1,1)^2+Ow(2,1)^2+Ow(3,1)^2);
O1a = [T1(1:3,4)];
O1 = sqrt(O1a(1,1)^2+O1a(2,1)^2+O1a(3,1)^2); 
P14a = Ow-O1a;
P14 = sqrt(P14a(1,1)^2+P14a(2,1)^2+P14a(3,1)^2);
P23 = sqrt(260^2+20^2);
 
a = atan(345/20);
b = acos((O4^2-O1^2-P14^2)/(-2*O1*P14));
c = acos((-P14^2-260^2+P23^2)/(-2*260*P14));
q2 = 2*pi-(pi/2+a+b+c);  %Ângulo A2
 
d = acos((P14^2-260^2-P23^2)/(-2*260*P23));
e = atan(260/20);
q3 = pi-d-e;             %Ângulo A3

 
T03 = (T1*T2*T3);
T36 = inv(T03)*T06;
 
q4 = atan2(T36(2,3),T36(1,3));                    %Ângulo A4
q5 = atan2(sqrt(T36(1,3)^2+T36(2,3)^2),T36(3,3)); %Ângulo A5
q6 = atan2(T36(3,2),-T36(3,1));                   %Ângulo A6
