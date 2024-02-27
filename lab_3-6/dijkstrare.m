function [wes1,wes2] = dijkstrare(dele,num_nodes,lognormal,puason,zert)
adjacency_matrix = zeros(num_nodes, num_nodes);
pu=puason;
lo=lognormal;
ze=zert;
% Заполняем матрицу смежности на основе информации о связях
for i = 1:size(dele, 1)
    node1 = dele(i, 1);
    node2 = dele(i, 2);
    adjacency_matrix(node1, node2) = 1;
    adjacency_matrix(node2, node1) = 1; % Учитываем обратное направление
end
disp([' '])
disp(['Матрица смежности'])
disp(adjacency_matrix); % Выводим матрицу смежности

disp([' '])
% Определяем интервал весов
min_weight = 2;
max_weight = 10;
mu = 2; % Среднее значение логарифма
sigma = 0.5; % Стандартное отклонение логарифма
lambda = 0.5; % Параметр экспоненциального распределения
% Создаем пустой массив весов ребер
disp([' '])
% Создаем пустой массив весов ребер
disp('Выберите тип распределения:');
disp('1. Равномерное');
disp('2. Логнормальное');
disp('3. Экспоненциальное');
disp([' '])
choice = input('Введите номер выбранного распределения: ');
disp([' '])
zer = zeros(size(adjacency_matrix));
logo = zeros(size(adjacency_matrix));
% Заполняем массив весов ребер в соответствии с матрицей смежности
for i = 1:size(adjacency_matrix, 1)
    for j = 1:size(adjacency_matrix, 2)
        if adjacency_matrix(i, j) == 1
            % Генерируем случайное значение из равномерного распределения в заданном интервале
            if choice==1
            weight = randi([min_weight, max_weight]);
            end
            if choice==2
            weight = lognrnd(mu, sigma);
            end
            if choice==3
            weight= exprnd(lambda);
            end
            edge_weights(i, j) = weight;
            edge_weights(j, i) = weight; % Задаем значение в обратную сторону
            zer(i,j)=ze(i);
            zer(j,i)=ze(i);
            logo(i,j)=lo(i);
            logo(j,i)=lo(i);
            if i==18
                zer(i,j)=1;
                zer(j,i)=1;
                logo(i,j)=1;
                logo(j,i)=1;

            end
        end
    end
end

disp([' '])
% Выводим полученные веса ребер
disp('Массив весов ребер:');
disp(edge_weights);
disp([' '])
n=num_nodes;
 

a = [];
b = [];
c = [];
for i = 1:n
    for j = 1:n
        % Проверяем, чтобы все три матрицы имели ненулевые веса для данного ребра
        if edge_weights(i,j) ~= 0 && logo(i,j) ~= 0 && zer(i,j) ~= 0
            % Находим минимальные значения из трех матриц
            min_weight1 = min(edge_weights(i,j));
            min_weight2 = min(logo(i,j));
            min_weight3 = min(zer(i,j));
            % Выбираем ребро, где все три значения ближе к своим минимальным
             min_diff_sum = (edge_weights(i,j) - min_weight1)^2 + (logo(i,j) - min_weight2)^2 + (zer(i,j) - min_weight3)^2;
            if min_diff_sum == min(min_diff_sum)
                a = [a,i];
                b = [b,j];
                c = [c, min_weight1]; % Можно выбрать любую из трех минимальных, так как они равны
            end
        end
    end
end

g = digraph(a,b,c);
[path,d] = shortestpath(g,1,18);
pp = num2str(path(1));
for i = 2:length(path)
    pp = [pp,'->',num2str(path(i))];
end
disp('Кратчайший путь');
disp(num2str(pp));
wes1 = path;
wes2 = d;

end