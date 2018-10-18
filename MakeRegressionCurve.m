%Calibration������ɏo�͂����csv����C���[�U�[�P�x�d�S�ƍ��x��LookUpTable�̊֐���A���s��
close all
clear all

%%
%�p�����[�^�[
csvfile = "C:\Users\Mikihiro Ikura\Documents\GitHub\HighSpeedCamera\sample\CameraAccessDirect\light_section_result.csv";
a = [];
b = [];
c = [];


M = importdata(csvfile);

%%
%2���֐��ɂ���A�Ȑ��̃p�����[�^�[�v�Z
%�P�x�d�S�ƍs�ԍ��̑���
for i=1:size(M,1)%��������
    X = [];
    Y = [];
    for j=2:size(M,2)%�s�ԍ�����
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
%������a,b,c�̑���
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