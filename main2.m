%% Reset
clc;
clear all;
close all;

%% Constantes

nb_rea = 1000;
nb_obs = 10;
varb = 2;
m = 4;
%% Parametres

%% Debut

  b = randn(nb_obs, nb_rea)*sqrt(varb);
  s = randn(nb_obs, nb_rea)*sqrt(varb) + m;
  
  PsH0 = sum(b, 1); % vu qu'on considère la somme de nos observations
  PsH1 = sum(s, 1); % du coup on peut mieux séparer
  
  figure;
  histogram(PsH0);
  hold on;
  histogram(PsH1);
  
  