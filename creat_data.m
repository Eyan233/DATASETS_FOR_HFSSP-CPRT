function [] = creat_data(scale, Pnum, jmin,jmax)
%CREAT_DATA 此处显示有关此函数的摘要
          % 产品总数
    Qum_in_P = randi([jmin, jmax],1,Pnum);

    Onum = 5;       % 工艺数/阶段数
    max_resource =100; % 最大资源供应
    Jnum = sum(Qum_in_P);    % 零件总数量
    ArriveTime = randi([0,20],1,Jnum);       % 到达时间

    OI(1).name="KR";
    OI(1).m = [1,2,3];
    OI(1).time = randi([40,60],1,Jnum);
    OI(1).resource = zeros(1,Jnum);

    OI(2).name="BOF";
    OI(2).m = [4,5,6];
    OI(2).time = randi([45,65],1,Jnum);
    OI(2).resource = randi([30,50],1,Jnum);

    OI(3).name="LF";
    OI(3).m = [7,8];
    OI(3).time = randi([40,60],1,Jnum);
    OI(3).resource = zeros(1,Jnum);

    OI(4).name="RF";
    OI(4).m = [9,10];
    OI(4).time = randi([40,70],1,Jnum);
    OI(4).resource = zeros(1,Jnum);

    OI(5).name="CC";
    OI(5).m = [11,12];
    OI(5).time = randi([20,40],1,Jnum);
    OI(5).resource = zeros(1,Jnum);

    Mnum = 12;
    % 运输时间
    Transport = [inf	inf	inf	15	17	20	inf	inf	inf	inf	inf	inf;
        inf	inf	inf	17	20	25	inf	inf	inf	inf	inf	inf;
        inf	inf	inf	25	17	15	inf	inf	inf	inf	inf	inf;
        inf	inf	inf	inf	inf	inf	10	15	inf	inf	inf	inf;
        inf	inf	inf	inf	inf	inf	12	17	inf	inf	inf	inf;
        inf	inf	inf	inf	inf	inf	15	20	inf	inf	inf	inf;
        inf	inf	inf	inf	inf	inf	inf	inf	10	15	inf	inf;
        inf	inf	inf	inf	inf	inf	inf	inf	13	18	inf	inf;
        inf	inf	inf	inf	inf	inf	inf	inf	inf	inf	5	10;
        inf	inf	inf	inf	inf	inf	inf	inf	inf	inf	10	5;
        inf	inf	inf	inf	inf	inf	inf	inf	inf	inf	inf	inf;
        inf	inf	inf	inf	inf	inf	inf	inf	inf	inf	inf	inf;
        ];
    SET = [5,5,5,8,8,8,3,3,3,3,6,6];    % 机器上设置时间

    %% 形成所有待加工信息
    jid = 0;
    oid = 0;
    oid2p = [];
    colors = jet(Jnum);
    for p=1:Pnum
        for j=1:Qum_in_P(p)
            jid = jid + 1;      % jid
            J(jid).p = p;       % 产品类型
            J(jid).arrive = ArriveTime(jid); %
            J(jid).color = colors(jid,:);
            J(jid).consume = 0;
            for o=1:Onum
                oid = oid + 1;
                J(jid).O(o).oid = oid;
                J(jid).O(o).jid = jid;
                J(jid).O(o).canstar = [];  % 可开始时间,机器号
                J(jid).O(o).waittime = 0; % 等待时间
                J(jid).O(o).waitsum = 0;  % 后续时间等待总和
                J(jid).O(o).canm = OI(o).m;
                J(jid).O(o).time = OI(o).time(jid);
                J(jid).O(o).consum = OI(o).resource(jid);
                J(jid).consume = J(jid).consume + J(jid).O(o).consum;
                J(jid).O(o).star = 0;
                J(jid).O(o).m = 0;
                J(jid).O(o).end = 0;
            end
        end
    end
    Oidnum = oid;
    %% 机器的信息
    for m=1:Mnum
        %-功能性
        if m<=3
            M(m).function = 1;
        elseif m<=6
            M(m).function = 2;
        elseif m<=8
            M(m).function = 3;
        elseif  m<=10
            M(m).function = 4;
        else
            M(m).function = 5;
        end
        %-属性
        M(m).done_oid = [];     % 处理过的oid
        M(m).first_star = 0;     % 首道工序开始时间
        M(m).done_num = 0;      % 处理过工序数
        M(m).last_oid = 0;      % 上一工序
        M(m).last_time = 0;     % 上一工序
        M(m).doing_time = 0;
        M(m).resouce_used =[];
        M(m).resouce_used_time =0;
    end

    oid=0;
    for jid =1:Jnum
        for o=1:5
            oid = oid+1;
            oid_jid(oid) = jid;
        end
    end

    dataname = ['scale' num2str(scale) '.mat'];
    save(dataname, 'ArriveTime','J','Jnum','M','max_resource','Mnum',"OI",'oid_jid',"Oidnum",'Onum','Pnum',"Qum_in_P",'SET','Transport');
    
    scale_data(scale).Pnum = Pnum;
    scale_data(scale).jnum = jid;
    scale_data(scale).oid = oid;
    scale_data(scale).Qnum = Qum_in_P;
end

