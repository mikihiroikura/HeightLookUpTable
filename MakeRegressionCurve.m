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
%ある行番号の時の輝度重心と高さの相関
Y = [];
for i=2:size(M,2)%画像の行ごと
    X = [];
    H = [];
    for j = 1:size(M,1)%高さごと
        if M(j,i)~=0
            X = [X,M(j,i)];
            H = [H,M(j,1)];
        end
    end
    if size(X,2) >=3
        p = polyfit(X,H,2);
        a = [a,p(1)];
        b = [b,p(2)];
        c = [c,p(3)];
        Y = [Y,i];
    end
end
RCurve = [a;b;c];
%%
%行方向とa,b,cの相関
Out = [];
param = [];
for i=1:size(RCurve,1)
    param = RCurve(i,:);
    p = polyfit(Y,param,2);
    Out = [Out;p];
end
%

%%
%表示用
close all;
f1 = figure;
f2 =figure;
f3 =figure;
y = min(Y):max(Y);
A = polyval(Out(1,:),y);
B = polyval(Out(2,:),y);
C = polyval(Out(3,:),y);
figure(f1);
plot(Y,a,'o',y,A);
figure(f2);
plot(Y,b,'o',y,B);
figure(f3);
plot(Y,c,'o',y,C);

%%
%ある行番号yの時，輝度重心xと高さの関係の表示
f4 =figure;
y = 200;
H_true = [];
X_true = [];
for i = 1:size(M,1)
    if M(i,y+1)~=0
        H_true = [H_true;M(i,1)];
        X_true = [X_true;M(i,y+1)];
    end
end
a_rec = polyval(Out(1,:),y);
b_rec = polyval(Out(2,:),y);
c_rec = polyval(Out(3,:),y);
X_rec = 0:1:640;
H_rec = a_rec*X_rec.^2+b_rec*X_rec+c_rec;

figure(f4);
plot(X_true,H_true,'o',X_rec,H_rec);