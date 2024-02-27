function [lognormal, puason] = erta(num_nodes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Параметры моделирования
% Количество узлов
num_samples = 10; % Количество сэмплов для генерации данных
num_inner_nodes = num_nodes - 2; % Узлы от 2 до 17

% Генерация данных
lambda_poisson = 5; % Параметр распределения Пуассона
mu_lognormal = 1; % Параметр среднего логнормального распределения
sigma_lognormal = 0.5; % Параметр стандартного отклонения логнормального распределения
k_erlang = 2; % Параметр формы распределения Эрланга
theta_erlang = 1; % Параметр масштаба распределения Эрланга

packet_counts_poisson = poissrnd(lambda_poisson, num_inner_nodes, num_samples); % Генерация числа приходящих пакетов по распределению Пуассона

% Рассчет фоновой занятости для каждого узла
background_occupancy_poisson = zeros(num_inner_nodes, 1);
background_occupancy_lognormal = zeros(num_inner_nodes, 1);
for i = 1:num_inner_nodes
    for j = 1:num_samples
        % Для распределения Пуассона
        background_occupancy_poisson(i) = background_occupancy_poisson(i) + packet_counts_poisson(i, j);
        % Для логнормального распределения
        packet_count_lognormal = round(lognrnd(mu_lognormal, sigma_lognormal));
        background_occupancy_lognormal(i) = background_occupancy_lognormal(i) + packet_count_lognormal;
    end
end
for i=1:num_inner_nodes
poisert(i,1)=sum(packet_counts_poisson(i, :));
end
% Вывод сообщений о количестве пакетов для каждого узла
fprintf('Число пакетов на каждый узел (распределение Пуассона):\n');
for i = 1:num_inner_nodes
    fprintf('Узел %d: %d пакетов', i+1, poisert(i, 1));
    fprintf('\n');
end
fprintf('\n');
disp([' '])
% Вывод сообщений о количестве пакетов для каждого узла (логнормальное распределение)
fprintf('Число пакетов на каждый узел (логнормальное распределение):\n');
for i = 1:num_inner_nodes
    total_packets = sum(round(lognrnd(mu_lognormal, sigma_lognormal, 1, num_samples)));
    lognter(i,1)=total_packets;
    fprintf(' Узел %d: %d пакетов ', i+1, total_packets);
    fprintf('\n');
end
fprintf('\n');

disp([' '])
% Построение карты фоновой занятости

% Построение карты фоновой занятости (распределение Пуассона)
figure;
bar(2:num_nodes-1, background_occupancy_poisson);
xlabel('Узлы');
ylabel('Пакеты');
title('Распределение пакетов по узлам (Пуассон)');

% Построение карты фоновой занятости (логнормальное распределение)
figure;
bar(2:num_nodes-1, background_occupancy_lognormal);
xlabel('Узлы');
ylabel('Пакеты');
title('Распределение пакетов по узлам (логнормальное)');
% Генерация времени для каждого пакета по распределению Эрланга
packet_processing_times_erlang_poison = zeros(num_inner_nodes, max(poisert));
packet_processing_times_erlang_logn = zeros(num_inner_nodes, max(lognter));
usumer_times_erlang_logn=zeros(num_inner_nodes,1);
usumer_times_erlang_pois=zeros(num_inner_nodes,1);
for i=1:num_inner_nodes
packet_processing_times_erlang_poison(i, 1:poisert(i)) = gamrnd(k_erlang, theta_erlang, 1, poisert(i));
 
end
for i=1:num_inner_nodes
packet_processing_times_erlang_logn(i, 1:lognter(i)) = gamrnd(k_erlang, theta_erlang, 1, lognter(i)); 
end
for i=1:num_inner_nodes
    usumer_times_erlang_logn(i,1)=sum(packet_processing_times_erlang_logn(i,:));
    usumer_times_erlang_pois(i,1)=sum(packet_processing_times_erlang_poison(i,:));
end
for i=1:num_inner_nodes
    
% Рассчет фоновой занятости для каждого узла по распределению Пуассона
background_occupancy_poisson(i) = round( usumer_times_erlang_pois(i));
end
for i=1:num_inner_nodes
 %Рассчет фоновой занятости для каждого узла по логнормальному распределению
background_occupancy_lognormal(i) =  round(usumer_times_erlang_logn(i));
end
% Построение карты фоновой занятости для распределения Пуассона
figure;
bar(2:num_nodes-1, background_occupancy_poisson);
xlabel('Узлы');
ylabel('Фоновая занятость (время)');
title('Карта фоновой занятости узлов системы (распределение Пуассона)');

% Построение карты фоновой занятости для логнормального распределения
figure;
bar(2:num_nodes-1, background_occupancy_lognormal);
xlabel('Узлы');
ylabel('Фоновая занятость (время)');
title('Карта фоновой занятости узлов системы (логнормальное распределение)');
figure;
puason=zeros(num_nodes,1);
puason(2:17) = background_occupancy_poisson;
lognormal=zeros(num_nodes,1);
 lognormal(2:17)= background_occupancy_lognormal;
end