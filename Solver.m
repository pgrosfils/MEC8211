%% MAIN FILE 
% Choisir le mode de simulation
simulationMode = 1;  % 1 : Solution numérique 
                     % 2 : Solution Analytique 
                     % 3 : Comparaison Numérique/ Analytique 
N = 100 ; % Nn Node 
diameter = 1; %m
stateVector = zeros(N,1); % vecteur d'etat 
radiusVector = (1:N)/N*diameter/2;
ratioCoeff = 10e-10; %m2/an
reactionConstant = 0;%4e-9 ; % 1/an
sourceTerm = 10e-8 .*ones(N,1) ; %mol/m3/s
initialConcentration = 10 ; % mol/m3
newmannBorderCondition = [1,0];
dirichletCondition = [N,initialConcentration];
dx = diameter/2/N;
dt = 1e11; %an

switch simulationMode
    case 1
%% Calcul généraux 
Dx=FirstDerivateSpaceMatrix(n,dx);
Dxx = SecondDerivateSpaceMatrix(n,dx);
[rightMemberMatrix] = DifferentialEquationRightMember(Dx,Dxx,N,dx,ratioCoeff,reactionConstant);

%% Loop 
t = 0:dt:1e13; %an
nbIter = length(t);
result = zeros(length(stateVector),nbIter);
for i = 1:nbIter
stateVector = EulerImplicitSolverStep(Dx,rightMemberMatrix,constantTerm,dt,stateVector,dirichletCondition,newmannBorderCondition);
result(:,i) = stateVector;
end

%% Display ( a completer ) 
[x,y ] = meshgrid(t,(1:N).*dx);
figure;
fig =mesh(x,y,result);
title('Titre');
xlabel('Temps (année)');
ylabel('Distance');
zlabel('Concentration');
figure 
plot(radiusVector,result(:,end))
    case 2 

%% Solution Analytique
[C] = AnalyticSolution(sourceTerm,diameter/2,initialConcentration,ratioCoeff,radiusVector);
plot(radiusVector,C);
end