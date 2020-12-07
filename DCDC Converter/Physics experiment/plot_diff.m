fsubplot(2,6,1);
plot(top_diff(1,:))
hold
plot(bot_diff(1,:))
grid on
ylim([-15 15])
title('WS = 4m/s')

subplot(2,6,2);
plot(top_diff(2,:))
hold
plot(bot_diff(2,:))
grid on
ylim([-15 15])
title('WS = 5m/s')

subplot(2,6,3);
plot(top_diff(3,:))
hold
plot(bot_diff(3,:))
grid on
ylim([-15 15])
title('WS = 5.5m/s')

subplot(2,6,4);
plot(top_diff(4,:))
hold
plot(bot_diff(4,:))
grid on
ylim([-15 15])
title('WS = 6.5m/s')

subplot(2,6,5);
plot(top_diff(5,:))
hold
plot(bot_diff(5,:))
grid on
ylim([-15 15])
title('WS = 7m/s')


subplot(2,6,7);
plot(top_diff_W(1,:))
hold
plot(bot_diff_W(1,:))
grid on
ylim([-15 15])
title('R=4M')

subplot(2,6,8);
plot(top_diff_W(2,:))
hold
plot(bot_diff_W(2,:))
grid on
ylim([-15 15])
title('R=5K')

subplot(2,6,9);
plot(top_diff_W(3,:))
hold
plot(bot_diff_W(3,:))
grid on
ylim([-15 15])
title('R=3K')

subplot(2,6,10);
plot(top_diff_W(4,:))
hold
plot(bot_diff_W(4,:))
grid on
ylim([-15 15])
title('R=1K')

subplot(2,6,11);
plot(top_diff_W(5,:))
hold
plot(bot_diff_W(5,:))
grid on
ylim([-15 15])
title('R=300')

subplot(2,6,12);
plot(top_diff_W(6,:))
hold
plot(bot_diff_W(6,:))
grid on
ylim([-15 15])
title('R=100')