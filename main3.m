%%
%
% Ce fichier : On rajoute une boucle pour voir une évolution du seuil
% en fonction de pfa
%
%% Reset
clc;
clear all;
close all;

%% Constantes
PLOT_PsH_ON = 0;


%% Parametres const
nb_rea = 100;
nb_obs = 10;
varb = 1;
m = 4;

Pfas_fix = [0:0.001:1];

%% Parametres

Pfas_th = zeros(size(Pfas_fix));
Pfas_expe = zeros(size(Pfas_fix));
seuils = zeros(size(Pfas_fix));

%% Debut

for i_pfa = 1:length(Pfas_fix)

    b = randn(nb_obs, nb_rea)*sqrt(varb);
    s = randn(nb_obs, nb_rea)*sqrt(varb) + m;

    PsH0 = sum(b, 1); % vu qu'on considère la somme de nos observations
    PsH1 = sum(s, 1); % du coup on peut mieux séparer

    if(PLOT_PsH_ON)
        figure;
        histogram(PsH0);
        hold on;
        histogram(PsH1);
    end

    hasard = randi([0 1], 1, nb_rea); % hypothèse sortante de la décision : 1 = H1 vrai
    yadusignal = logical(hasard); % H1 = un signal d'interet est present a la realisation ri
    nb_echsignal = sum(yadusignal);
    nb_echbruit =  nb_rea-nb_echsignal;

    signal_sans_bruit = repmat(yadusignal*m, 10, 1);

    obs = b;
    obs = obs + signal_sans_bruit;

    %% seuil

    seuil_lambda = sqrt(2*nb_obs*varb)*erfcinv(2*Pfas_fix(i_pfa));

    %% decision

    decision = sum(obs, 1) > seuil_lambda;
    nb_detection = sum(decision)

    errs = sum(decision ~= yadusignal);

    %% Proba experimentales

    Pd = sum(yadusignal & decision)/nb_echsignal;
    Pdet_manquees = sum(yadusignal & ~decision)/nb_echsignal; % normalement ça vaut 1-Pd

    Pfa = sum(~yadusignal & decision)/nb_echbruit;

    %% Proba théoriques

    % Q10
    % lambda = seuil_lambda*5 et on voit que c'est pas égal et que c'est bien
    % pas basé sur les observations
    Pd_th = 1/2*erfc( (seuil_lambda - nb_obs*m)/sqrt(2*nb_obs)*sqrt(varb) );
    Pfa_th = 1/2*erfc(seuil_lambda/sqrt(2*nb_obs*varb));
    
    Pfa_expe(i_pfa) = Pfa;
    Pfas_th(i_pfa) = Pfa_th;
    seuils(i_pfa) = seuil_lambda;
  
end

plot(Pfas_th, seuils);
hold on;
plot(Pfas, seuils);

    