function dy=FX_Lorenz(~,y,coe)
%coe:Ϊ1*3�����飬[o r b]
dy=zeros(3,1);
dy(1)=coe(1)*(-y(1)+y(2));
dy(2)=coe(2)*y(1)-y(2)-y(1)*y(3);
dy(3)=y(1)*y(2)-coe(3)*y(3);

