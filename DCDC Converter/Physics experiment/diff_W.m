top_diff_W=zeros(6,4);
top_diff_W(1,1)=max(PPy_U40_4000000)-max(PPy_U50_4000000);
top_diff_W(1,2)=max(PPy_U50_4000000)-max(PPy_U55_4000000);
top_diff_W(1,3)=max(PPy_U55_4000000)-max(PPy_U65_4000000);
top_diff_W(1,4)=max(PPy_U65_4000000)-max(PPy_U70_4000000);

top_diff_W(2,1)=max(PPy_U40_5000)-max(PPy_U50_5000);
top_diff_W(2,2)=max(PPy_U50_5000)-max(PPy_U55_5000);
top_diff_W(2,3)=max(PPy_U55_5000)-max(PPy_U65_5000);
top_diff_W(2,4)=max(PPy_U65_5000)-max(PPy_U70_5000);

top_diff_W(3,1)=max(PPy_U40_3000)-max(PPy_U50_3000);
top_diff_W(3,2)=max(PPy_U50_3000)-max(PPy_U55_3000);
top_diff_W(3,3)=max(PPy_U55_3000)-max(PPy_U65_3000);
top_diff_W(3,4)=max(PPy_U65_3000)-max(PPy_U70_3000);

top_diff_W(4,1)=max(PPy_U40_1000)-max(PPy_U50_1000);
top_diff_W(4,2)=max(PPy_U50_1000)-max(PPy_U55_1000);
top_diff_W(4,3)=max(PPy_U55_1000)-max(PPy_U65_1000);
top_diff_W(4,4)=max(PPy_U65_1000)-max(PPy_U70_1000);

top_diff_W(5,2)=max(PPy_U50_300)-max(PPy_U55_300);
top_diff_W(5,3)=max(PPy_U55_300)-max(PPy_U65_300);
top_diff_W(5,4)=max(PPy_U65_300)-max(PPy_U70_300);

top_diff_W(6,2)=max(PPy_U50_100)-max(PPy_U55_100);
top_diff_W(6,3)=max(PPy_U55_100)-max(PPy_U65_100);

bot_diff_W=zeros(6,4);
bot_diff_W(1,1)=min(PPy_U40_4000000)-min(PPy_U50_4000000);
bot_diff_W(1,2)=min(PPy_U50_4000000)-min(PPy_U55_4000000);
bot_diff_W(1,3)=min(PPy_U55_4000000)-min(PPy_U65_4000000);
bot_diff_W(1,4)=min(PPy_U65_4000000)-min(PPy_U70_4000000);

bot_diff_W(2,1)=min(PPy_U40_5000)-min(PPy_U50_5000);
bot_diff_W(2,2)=min(PPy_U50_5000)-min(PPy_U55_5000);
bot_diff_W(2,3)=min(PPy_U55_5000)-min(PPy_U65_5000);
bot_diff_W(2,4)=min(PPy_U65_5000)-min(PPy_U70_5000);

bot_diff_W(3,1)=min(PPy_U40_3000)-min(PPy_U50_3000);
bot_diff_W(3,2)=min(PPy_U50_3000)-min(PPy_U55_3000);
bot_diff_W(3,3)=min(PPy_U55_3000)-min(PPy_U65_3000);
bot_diff_W(3,4)=min(PPy_U65_3000)-min(PPy_U70_3000);

bot_diff_W(4,1)=min(PPy_U40_1000)-min(PPy_U50_1000);
bot_diff_W(4,2)=min(PPy_U50_1000)-min(PPy_U55_1000);
bot_diff_W(4,3)=min(PPy_U55_1000)-min(PPy_U65_1000);
bot_diff_W(4,4)=min(PPy_U65_1000)-min(PPy_U70_1000);

bot_diff_W(5,2)=min(PPy_U50_300)-min(PPy_U55_300);
bot_diff_W(5,3)=min(PPy_U55_300)-min(PPy_U65_300);
bot_diff_W(5,4)=min(PPy_U65_300)-min(PPy_U70_300);

bot_diff_W(6,2)=min(PPy_U50_100)-min(PPy_U55_100);
bot_diff_W(6,3)=min(PPy_U55_100)-min(PPy_U65_100);


