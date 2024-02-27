function xita = ferra(first_node_array,num_nodes,res1,res2,dele,ires)
%FERRA Summary of this function goes here
%   Detailed explanation goes here

reset=dele;
for i=1:num_nodes
    z=reset(i,1);
    y=reset(i,2);
    reset(i,3:4)=first_node_array(z,1:2);
    reset(i,5:6)=first_node_array(y,1:2);
end
der=21;
for i=1:ires
    for j=1:18
if(first_node_array(j,1)==res1(i,1) && first_node_array(j,2)==res1(i,2))
reset(der,1)=j;
reset(der,3:4)=res1(1:2);
continue
end
    end
    der=der+1;
end
zer=20;
for i=1:ires
        zer=zer+1;
    for j=1:18
if(first_node_array(j,1)==res2(i,1) && first_node_array(j,2)==res2(i,2))
reset(zer,2)=j;
reset(zer,5:6)=res2(1:2);
end
    end
end
num_rows = size(reset, 1);
for i=1:num_rows
    xetam=randi([1,100]);
    reset(i,7)=xetam;
end

xita=reset;
end

