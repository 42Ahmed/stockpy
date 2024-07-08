% Read in File from Excel

num = xlsread('Figure_17_3.xlsx','A3:F758');
cal = num(:,1);
ret = num(:,2);
rvu = num(:,3);
rvl = num(:,4);
gau = num(:,5);
gal = num(:,6);

plot(cal,ret,'-','color',rgb('grey'));
lw = 2;
hold on;
  plot(cal,rvl,'- k','LineWidth',lw);
  plot(cal,rvu,'- k','LineWidth',lw);
  plot(cal,gal,'- b','LineWidth',lw);
  plot(cal,gau,'- b','LineWidth',lw);
hold off;
xlim([2015 2018]);
ax = gca;
ax.FontSize = 25;
ylabel('Percent per day');


