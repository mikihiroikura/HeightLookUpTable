%Calibrationした後に出力されるcsvから，レーザー輝度重心と高度のLookUpTableの関数回帰を行う
close all
clear all

%%
%パラメーター
csvfile = "C:\Users\Mikihiro Ikura\Documents\GitHub\HighSpeedCamera\sample\CameraAccessDirect\light_section_result.csv";
a = [];
b = [];
c = [];


M = importdata(csvfile);

%%
%2次関数による回帰曲線のパラメーター計算
%輝度重心と行番号の相関
for i=1:size(M,1)%高さごと
    X = [];
    Y = [];
    for j=2:size(M,2)%行番号ごと
        if M(i,j) ~= 0
            X = [X;M(i,j)];
            Y = [Y;j-1];
        end
    end
    p = polyfit(X,Y,2);
    a = [a,p(1)];
    b = [b,p(2)];
    c = [c,p(3)];
end
RCurve = [a;b;c];
%%
%高さとa,b,cの相関
Out = [];
param = [];
height = M(:,1);
height = transpose(height);
for i=1:size(RCurve,1)
    param = RCurve(i,:);
    p = polyfit(height,param,2);
    Out = [Out;p];
end
%