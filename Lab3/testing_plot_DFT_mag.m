% Testing Script
close all;
figure_num = 1;

% Test 1
num_samples1 = 100;
a1 = 1; fsample1 = 20; phase1 = 0; f1 = 8; t1 = 0:1/fsample1:(num_samples1-1)/fsample1; %100 samples
% test 1 array
x1 = a1*cos(2*pi*f1*t1 + phase1);
plot_DFT_mag(x1, fsample1, figure_num);

% Test 2
a2 = 1; fsample2 = 20; phase2 = 0; f2 = 10; t2 = 0:1/fsample2:(num_samples1-1)/fsample2; %100 samples
% test 1 array
x2 = a2*cos(2*pi*f2*t2 + phase2);
plot_DFT_mag(x2, fsample2, figure_num+1);

% Test 3
a3 = 1; fsample3 = 20; phase3 = 0; f3 = 12; t3 = 0:1/fsample3:(num_samples1-1)/fsample3; %100 samples
% test 1 array
x3 = a3*cos(2*pi*f3*t3 + phase3);
plot_DFT_mag(x3, fsample3, figure_num+2);

% Test 4
a4 = 1; fsample4 = 20; phase4 = 0; f4 = 7.05; t4 = 0:1/fsample4:(num_samples1-1)/fsample4; %100 samples
% test 1 array
x4 = a4*cos(2*pi*f4*t4 + phase4);
plot_DFT_mag(x4, fsample4, figure_num+3);

% Test 5
num_samples5_1 = 100;
num_samples5_2 = 100;
a5_1 = 1; fsample5_1 = 20; phase5_1 = 0; f5_1 = 10; t5_1 = 0:1/fsample5_1:(num_samples5_1-1)/fsample5_1; %100 samples
a5_2 = 0.25; fsample5_2 = 20; phase5_2 = 0; f5_2 = 8.17; t5_2 = 0:1/fsample5_2:(num_samples5_2-1)/fsample5_2;
% test 1 array
x5_1 = a5_1*cos(2*pi*f5_1*t5_1 + phase5_1);
x5_2 = a5_2*cos(2*pi*f5_2*t5_2 + phase5_2);
x5 = x5_1 + x5_2;
plot_DFT_mag(x5, fsample5_1, figure_num+4);

% Test 6
x6 = x5.*blackman(100).';
plot_DFT_mag(x6, fsample5_1, figure_num+5);

% Test 7
num_samples7_1 = 200;
num_samples7_2 = 200;
a7_1 = 1; fsample7_1 = 20; phase7_1 = 0; f7_1 = 10; t7_1 = 0:1/fsample7_1:(num_samples7_1-1)/fsample7_1; %200 samples
a7_2 = 0.25; fsample7_2 = 20; phase7_2 = 0; f7_2 = 8.17; t7_2 = 0:1/fsample7_2:(num_samples7_2-1)/fsample7_2;
% test 1 array
x7_1 = a7_1*cos(2*pi*f7_1*t7_1 + phase7_1);
x7_2 = a7_2*cos(2*pi*f7_2*t7_2 + phase7_2);
x7 = x7_1 + x7_2;
plot_DFT_mag(x7, fsample7_1, figure_num+6);

% Test 8
x8 = x7.*blackman(200).';
plot_DFT_mag(x8, fsample7_1, figure_num+7);

% Test 9
num_samples9_1 = 200;
num_samples9_2 = 200;
a9_1 = 1; fsample9_1 = 20; phase9_1 = 0; f9_1 = 7.05; t9_1 = 0:1/fsample9_1:(num_samples9_1-1)/fsample9_1; %100 samples
a9_2 = 1; fsample9_2 = 20; phase9_2 = 0; f9_2 = 7.25; t9_2 = 0:1/fsample9_2:(num_samples9_2-1)/fsample9_2;
x9_1 = a9_1*cos(2*pi*f9_1*t9_1 + phase9_1);
x9_2 = a9_2*cos(2*pi*f9_2*t9_2 + phase9_2);
x9 = x9_1 + x9_2;
plot_DFT_mag(x9, fsample9_1, figure_num+8);

% Test 10
x10 = x9.*blackman(200).';
plot_DFT_mag(x10, fsample9_1, figure_num+9);

% Test 11
[hn_1, n_1] = unit_sample(40);
fsample_11 = 20;
plot_DFT_mag(hn_1, 1000, figure_num+10);

% Test 12
[hn_2, n_2] = unit_sample_response([.2 .2 .2 .2 .2], [1], 40, 12);
plot_DFT_mag(hn_2, 1000, figure_num+11);





