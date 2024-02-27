clc;
clear all;
close all;
min_value = 1.2;
max_value = 4.8;
num_values = 4;

% Создание чисел с минимальным расстоянием 0.2
step = 0.9;
zet = linspace(min_value, max_value, num_values) + rand(1, num_values) * step + step/2;

%zet= 1.2 + (4.8 - 1.2) * rand(4, 1);
lambda_min = 0.1;
lambda_max = 0.5;
%lambda = (lambda_max - lambda_min) .* rand(num_nodes, 1) + lambda_min;
% Распределение Вейбула
alpha_min = 0.5;
alpha_max = 1;
%alpha = (alpha_max - alpha_min) .* rand(num_nodes, 1) + alpha_min;
beta_min = 0.5;
beta_max = 1;
%beta = (beta_max - beta_min) .* rand(num_nodes, 1) + beta_min;
% Создание сети узлов
num_groups = 4; % Количество групп узлов
nodes_per_group = 4; % Количество узлов в каждой группе
num_nodes = num_groups * nodes_per_group + 2; % Общее количество узлов (включая пункты A и B)
first_node_array = zeros(num_nodes,2);
% Координаты узлов
random_values = 1.2 + (4.8 - 1.2) * rand(4, 1); % Случайная матрица размером 4x1
sorted_random_values = sort(random_values);
x_coords = [1, sorted_random_values', 5]; % Преобразуем матрицу в одномерный массив и добавляем к вектору x_coords
 % X-координаты узлов (A - 1, B - 3, остальные по бокам)
y_coords = [1, linspace(2, 8, num_groups), 9]; % Y-координаты узлов (A и B на одной высоте, остальные равномерно разбиты)

% Создание рисунка
figure;
hold on;
first_node_array(1,:)=[x_coords(1), y_coords(1)];
first_node_array(18,:)=[x_coords(6), y_coords(6)];
scatter(x_coords(1), y_coords(1), 'filled');
scatter(x_coords(6), y_coords(6), 'filled');
offset = 0.2;
z=2;% точки на узлах
for i= 1:num_groups
    for j=1:nodes_per_group
        scatter(x_coords(j+1), y_coords(i+1), 'filled', 'MarkerFaceColor', 'blue');
        text(x_coords(j+1), y_coords(i+1) + offset, num2str(z), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

        first_node_array(z,:)=[x_coords(j+1), y_coords(i+1)];
        z=z+1;
    end
end
first_node_array(:,3)= (lambda_max - lambda_min) .* rand(num_nodes, 1) + lambda_min;
first_node_array(:,4)= (alpha_max - alpha_min) .* rand(num_nodes, 1) + alpha_min; %форма
first_node_array(:,5)= (beta_max - beta_min) .* rand(num_nodes, 1) + beta_min; %масштаб
% Создание массива с координатами узлов
node_coordinates = [x_coords; y_coords]';
z=2;% Соединение узлов с пунктом A и В
for group = 1:num_groups
    start_node = 2 + (group - 1);
    end_node = start_node + nodes_per_group - 1;
    for i = start_node:start_node+nodes_per_group-1
        if i == start_node % Если это первый элемент группы
           plot([x_coords(1), x_coords(2)], [y_coords(1), y_coords(i)], 'k'); % Соединяем узлы с пунктом 
        end
        if i == end_node % Если это последний элемент групп
            plot([x_coords(6), x_coords(5)], [y_coords(end), y_coords(z)], 'k'); % Соединяем узел с пунктом B
            z=z+1;
        end
    end
end
z=2;% связи между группами
for group = 1:num_groups
       j=2;
    start_node = 2 + (group - 1) ;
    end_node = start_node + nodes_per_group - 1;
    for i = start_node:end_node-1
            plot([x_coords(j), x_coords(j+1)], [y_coords(z), y_coords(z)], 'b-'); % Соединяем узлы внутри группы пунктирными линиями 
    j=j+1;
    end
    z=z+1;
end
dele=[1,2;1,6;1,10;1,14;2,3;3,4;4,5;6,7;7,8;8,9;10,11;11,12;12,13;14,15;15,16;16,17;5,18;9,18;13,18;17,18];
ires = randi([1, 4]);
%ires=4;
erwq=21;
[res1,res2]=fonovi(first_node_array,ires);%фоновые потоки
for i=1:ires
x1 = res1(i,1);
y1 = res1(i,2);
x2 = res2(i,1);
y2 = res2(i,2);

dele(erwq,1)=res1(i,6);
dele(erwq,2)=res2(i,6);
erwq=erwq+1;
% Решаем систему уравнений для нахождения коэффициентов параболы
A = [x1^2 x1 1; x2^2 x2 1];
b = [y1; y2];
coefficients = A\b;
if coefficients(2,1) == 0 && coefficients(3,1) == 0
    plot([res1(i,1),res2(i,1)], [res1(i,2),res2(i,2)], 'r');
else
% Создаем параболу
x = linspace(x1, x2, 100); % Генерируем значения x для параболы
y = coefficients(1)*x.^2 + coefficients(2)*x + coefficients(3);
plot(x, y, 'r');
end
end


% Время работы системы (может быть любым значением)
time = 100; 
zert=zeros(num_nodes,1);
% Экспоненциальное распределение
prob_exp = prod(exp(-first_node_array(2:17,3) )); %функция надежности (вероятность безотказной работы)
 system_prob = 1 - prod(1 - first_node_array(2:17,3));
 
     
     zert(2:17)=(1 - first_node_array(2:17,3));
disp([' '])
disp(['Вероятность работы системы (экспоненциальное распределение): ', num2str(system_prob)]);
% Вывод результатов
disp([' '])
disp(['Вероятность работы системы (вероятность отказа работы) (экспоненциальное распределение): ', num2str(prob_exp)]);
% Расчет вероятности работы каждого узла
disp([' '])
j=0;
for i=2:17
    j=j+1;
node= exp(-(first_node_array(i,5)*time).^first_node_array(i,4));
node_probs(j,:)=node;
end
% Расчет вероятности работы системы
system_prob = prod(node_probs);
disp(['Вероятность работы системы (вероятность отказа работы) (распределение Вейбула): ', num2str(system_prob)]);
disp([' '])
disp(['Вероятность работы системы (распределение Вейбула): ', num2str(1-system_prob)]);
disp([' '])
xite=ferra(first_node_array,num_nodes,res1,res2,dele,ires);
[lognormal, puason]=erta(num_nodes);
% Настройка графика
xlim([0.5, 6]);
ylim([0.5, 10]);
axis equal;
title('Графическое представление сети узлов');
xlabel('X');
ylabel('Y');
grid on;
hold off;
[wes1,wes2] = dijkstrare(dele,num_nodes,lognormal,puason,zert);%дийкстра

disp('«Кратчайшая стоимость»');
disp(num2str(wes2));
yre=size(wes1);
%второй график для пути
figure('Position',[0,0,800,600]);
xlim([1, 6]);
ylim([1, 10]);
hold on;

scatter(x_coords(1), y_coords(1), 'filled');
scatter(x_coords(6), y_coords(6), 'filled');
z=2;
for i= 1:num_groups
    for j=1:nodes_per_group
        scatter(x_coords(j+1), y_coords(i+1), 'filled', 'MarkerFaceColor', 'blue');
        text(x_coords(j+1), y_coords(i+1) + offset, num2str(z), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

         z=z+1;
    end
end
node_coordinates = [x_coords; y_coords]';
z=2;% Соединение узлов с пунктом A и В
for group = 1:num_groups
    start_node = 2 + (group - 1);
    end_node = start_node + nodes_per_group - 1;
    for i = start_node:start_node+nodes_per_group-1
        if i == start_node % Если это первый элемент группы
           plot([x_coords(1), x_coords(2)], [y_coords(1), y_coords(i)], 'k'); % Соединяем узлы с пунктом 
        end
        if i == end_node % Если это последний элемент групп
            plot([x_coords(6), x_coords(5)], [y_coords(end), y_coords(z)], 'k'); % Соединяем узел с пунктом B
            z=z+1;
        end
    end
end
z=2;% связи между группами
for group = 1:num_groups
       j=2;
    start_node = 2 + (group - 1) ;
    end_node = start_node + nodes_per_group - 1;
    for i = start_node:end_node-1
            plot([x_coords(j), x_coords(j+1)], [y_coords(z), y_coords(z)], 'b-'); % Соединяем узлы внутри группы пунктирными линиями 
    j=j+1;
    end
    z=z+1;
end
for i=1:ires
x1 = res1(i,1);
y1 = res1(i,2);
x2 = res2(i,1);
y2 = res2(i,2);

% Решаем систему уравнений для нахождения коэффициентов параболы
A = [x1^2 x1 1; x2^2 x2 1];
b = [y1; y2];
coefficients = A\b;
if coefficients(2,1) == 0 && coefficients(3,1) == 0
    plot([res1(i,1),res2(i,1)], [res1(i,2),res2(i,2)], 'g');
else
% Создаем параболу
x = linspace(x1, x2, 100); % Генерируем значения x для параболы
y = coefficients(1)*x.^2 + coefficients(2)*x + coefficients(3);
plot(x, y, 'g');
end
end
for i=1:yre(2)
scatter(first_node_array(wes1(i),1), first_node_array(wes1(i),2), 'filled', 'MarkerFaceColor', 'red');       
end


title('Графическое представление сети узлов');
xlabel('X');
ylabel('Y');
grid on;
zoom on;
hold off;
cc=yre(2)-1;
lopa=0;
pupa=0;
for i=2:cc
popa=lognormal(wes1(1,i),1);
papa=puason(wes1(1,i),1);
lopa=lopa+popa;
pupa=pupa+papa;
end
disp([' '])
disp(['Вывод времени обработки фона на пути log ',num2str(lopa),' Puason ',num2str(pupa)])
disp([' '])
mu = 2; % Среднее значение логарифма
sigma = 0.5; % Стандартное отклонение логарифма
mu_stream = 3; % Среднее значение логарифма
sigma_stream = 0.7; % Стандартное отклонение логарифма
lambda = 5; % параметр распределения Пуассона
z=0;
for i=2:cc
    z=z+1;
poisson_random1(z,1) = poissrnd(lambda);
log_random1(z,1) = lognrnd(mu_stream, sigma_stream);
packet_log_random(z,:) = lognrnd(mu, sigma, 1, 7);
packet_poisson_random(z,:) = poissrnd(lambda,1,7);
end
anspu=sum(poisson_random1);
anslo=sum(log_random1);
anslopa=sum(packet_log_random(:));
anspupa=sum(packet_poisson_random(:));
disp([' '])
disp(['Временя обработки пакетов одиночек на пути log ',num2str(anslo),' дейтаграммой ',num2str(anslopa)])
disp([' '])
disp(['Временя обработки пакетов одиночек на пути puason ',num2str(anspu),' дейтаграммой ',num2str(anspupa)])
disp([' '])
anspu=anspu+pupa;
anspupa=anspupa+pupa;
anslo=anslo+lopa;
anslopa=anslopa+lopa;
disp([' '])
disp(['Итоговое время обработки пакетов одиночек на пути log ',num2str(anslo),' дейтаграммой ',num2str(anslopa)])
disp([' '])
disp(['Итоговое время пакетов одиночек на пути puason ',num2str(anspu),' дейтаграммой ',num2str(anspupa)])