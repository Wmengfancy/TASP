%��ͬ�Ĳ��ж�  Plot_DifferentConst
%�������ʹ���������������ͼ

% Tasknum = 20;
% Servernum = 2;
% userNum = 2;
% Tasknum = 100;
% Servernum = 10;
% userNum = 50;
Tasknum = 25;
Servernum = 5;
userNum = 1;


%[ServerMemory,TaskMemory,Possionrate,Transferrate,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData(userNum,Servernum,Tasknum);
[ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/4),userNum,Servernum,Tasknum);


%const  = 4:4:20;
%const = 10:-1:1;
const = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]
len = length(const(:));
for i = 1:len
    
    for times = 1:10
    Graph = GenarateGraphParallel(Tasknum,const(i)); 
    
    %[Taskgraph,Graph] = GenarateGraphCommon_2(Graph,Tasknum,userNum,0.3); %��������ռ��0.3
     % ��������userNumΪ1��ֱ�Ӹ�Taskgraph��ֵ������
    Taskgraph = zeros(Tasknum,Tasknum,userNum);
    Taskgraph(:,:,1) = Graph;
    
    Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);
    
    y_1
    for k = 1.5:0.5:4
        [~,~,preFinishTime_best] = P1_IterateNum_network(6000,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
        
    end
    
%     for j = 1 : userNum
%         [~, ~] = countTaskLayer(Taskgraph(:,:,j),Tasknum,times,const(i),j);
%     end

    
    %[preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3] = P3_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
     
     
    %[preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
     %[preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
   % [preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
     
    %[preCache_infocom2,preTaskComputationSpeed_infocom2,preFinishTime_infocom2] = Copy_of_P1_infocom(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    %[preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);

         
    const(i)
    
%     y(i) = preFinishTime_p3;
%     y2(i) = preFinishTime_infocom;
%     y3(i) = preFinishTime_iwqos;
    
   % z(i,times) = preFinishTime_p3;
    %z2(i,times) = preFinishTime_infocom;
    %z3(i,times) =  preFinishTime_iwqos;
    z4(i,times) = preFinishTime_best;
    end
end

% z(1:9) = x(1:9)/20 * 100;

% plot(const,y);
% hold on;
% plot(const,y2);
% plot(const,y3);

% plot(z,y);
% hold on;
% %plot(x,y2);
% plot(z,y4);
% plot(z,y3);

for i = 1 : length(const)
   % y(i) = mean(z(i,:));
   % y2(i) = mean(z2(i,:));
   % y3(i) = mean(z3(i,:));
    y4(i) = mean(z4(i,:));
end

hold on;
plot(const,y4);%best%
%plot(const,y);
%plot(const,y2);%ICE
%plot(const,y3);%GenDoc
