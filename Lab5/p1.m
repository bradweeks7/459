%% Load all data
all_data = load('SubSonar.mat');
Akula = all_data.AkulaSubEcho;
LA = all_data.LosAngelesSubEcho;
Typhoon = all_data.TyphoonSubEcho;
Tx_pulse = all_data.TxPulse;

AkulaSamples = 1:2501;
Fs = 50000;
tAkula = AkulaSamples/Fs;

%% Plot Time Domain Data in 2x2 Grid w/ labels
figure(1);
title('Time-Domain Echo Data');
%Akula
subplot(2,2,1);
plot(tAkula, Akula);
title('Akula Submarine Echo Time-Domain Data');
xlabel(' Time (ms) ');
ylabel(' Amplitude (V) ');

%Los Angeles
subplot(2,2,2);
plot(tAkula, LA);
title('Los Angeles Submarine Echo Time-Domain Data');
xlabel(' Time (ms) ');
ylabel(' Amplitude (V) ');

%Typhoon
subplot(2,2,3);
plot(tAkula, Typhoon);
title('Typhoon Submarine Echo Time-Domain Data');
xlabel(' Time (ms) ');
ylabel(' Amplitude (V) ');

%Tx Pulse
subplot(2,2,4);
plot(tAkula, Tx_pulse);
title('TX Pulse Time-Domain Data');
xlabel(' Time (ms) ');
ylabel(' Amplitude (V) ');

%% FFT For Each Signal

fft_akula   = fft(Akula);
fft_LA      = fft(LA);
fft_Typhoon = fft(Typhoon);
fft_tx      = fft(Tx_pulse);

Fd = 0:1/length(Akula):(1-1/length(Akula));
Fa = Fd.*Fs;


figure(2);
subplot(2,2,1);
plot(Fa, fft_akula);



