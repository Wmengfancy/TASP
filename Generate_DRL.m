function [Taskgraph,TaskMemory,Computespeed_Local] = Generate_DRL(userNum)
Graph_compute = [23,26,0,0,0,29,0,21,0;
    -23,26,28,0,0,0,0,0,0;
    0,-28,19,31,0,0,0,0,0;
    0,0,-31,28,30,0,0,0,23;
    0,0,0,-30,19,0,21,0,0;
    -29,0,0,0,0,22,17,0,0;
    0,0,0,0,-21,-17,11,0,0;
    -21,0,0,0,0,0,0,18,31;
    0,0,0,-23,0,0,0,-31,28
    ];
Local_speed = [3.6371,4.6852,4.9355,3.1236,3.4247,2.5996,4.7373,4.6366,4.2914]*0.05;
Taskgraph = zeros(9,9,userNum);
TaskMemory = [56,65,78,21,55,48,25,78,52];
Computespeed_Local = zeros(9,userNum);
for i =1:userNum
    Taskgraph(:,:,i) = Graph_compute;
    Computespeed_Local(:,i) = Local_speed;
end