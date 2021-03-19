%%Time specifications:
   F1 = 200;                   % samples per second
   F2 = 60;
   F3 = 20;
   F4 = 20;
   F5 = 12;

   dt1 = 1/F1;                   % seconds per sample
   dt2 = 1/F2;
   dt3 = 1/F3;
   dt4 = 1/F4;
   dt5 = 1/F5;
   
   StopTime = 0.5;             % seconds
   
   t1 = (0:dt1:StopTime-dt1)';     % seconds
   t2 = (0:dt2:StopTime-dt2)';     % seconds
   t3 = (0:dt3:StopTime-dt3)';     % seconds
   t4 = (0:dt4:StopTime-dt4)';     % seconds
   t5 = (0:dt5:StopTime-dt5)';     % seconds
   
   %%Sine wave:
   Fc = 10;                     % hertz
   x1 = cos(2*pi*Fc*t1 + pi/3);
   x2 = cos(2*pi*Fc*t2 + pi/3);
   x3 = cos(2*pi*Fc*t3 + pi/3);
   x4 = cos(2*pi*Fc*t4 + pi/3);
   x5 = cos(2*pi*Fc*t5 + pi/3);
   
   % Plot the signal versus time:
   figure(1);
   hold
   plot(t1,x1, 'b','LineWidth', 4);
   xlabel('Time (Seconds)');
   ylabel('Amplitude');
   plot(t2,x2, 'r', 'LineWidth', 3);
   plot(t3,x3, 'g','LineWidth', 2);
   plot(t4,x4, '--g', 'LineWidth', 5);
   plot(t5,x5, 'k','LineWidth', 6);
   title('Signal versus Time');