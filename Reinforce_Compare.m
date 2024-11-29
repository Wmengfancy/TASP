%ǿ��ѧϰ AC������DAG�����ǵ��㷨��infocom20��iwqos19���㷨�Ա�
%Reinforce_Compare

Tasknum = 9;
userNum = 1; %ֻ��һ��DAG��û�кϳ�
Servernum = 2;

%�������GenarateGraphParalle�����õ�Graph��Graph�Ѿ�����
Graph = zeros(Tasknum,Tasknum);
Graph(1,:) = [1,1,0,0,0,1,0,1,0];
Graph(2,:) = [-1,1,1,0,0,0,0,0,0];
Graph(3,:) = [0,-1,1,1,0,0,0,0,0];
Graph(4,:) = [0,0,-1,1,1,0,0,0,1];
Graph(5,:) = [0,0,0,-1,1,0,1,0,0];
Graph(6,:) = [-1,0,0,0,0,1,1,0,0];
Graph(7,:) = [0,0,0,0,-1,-1,1,0,0];
Graph(8,:) = [-1,0,0,0,0,0,0,1,1];
Graph(9,:) = [0,0,0,-1,0,0,0,-1,1];

%�������GenarateGraphCommon�����õ�Taskgraph����һ���û�DAG������Graph
Taskgraph = zeros(Tasknum,Tasknum,userNum);
Taskgraph(:,:,1) = Graph;


%[ServerMemory,TaskMemory,Possionrate,Transferrate,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData(userNum,Servernum,Tasknum);
 [ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/2),userNum,Servernum,Tasknum);


% EdgeWeight = zeros(Tasknum,Tasknum);
% for i = 1:(Tasknum-1)
%     for j=(i+1):Tasknum
%         %EdgeWeight(i,j) = randi([16 64]); 
%         EdgeWeight(i,j) = normrnd(15,5,[1 1]);
%     end
% end

Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);

%[preCache,preTaskComputationSpeed,preFinishTime] = P1_RankOnNum(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
[preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3] = P3_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);


% IWQoS
%[preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
[preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);


%infocom 2020
%preCache_infocom��TaskComputationSpeed2��AvgFinishtime2�ǽ��
%[preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = Copy_of_P1_infocom(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
[preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);




%[TaskComputationSpeed2,AvgFinishtime2] = P2(Tasknum,userNum,Servernum,preCache_infocom,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
