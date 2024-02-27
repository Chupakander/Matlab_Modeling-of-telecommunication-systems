clc;
clear all;
close all;

% Генерация распределения Пуассона с параметром lambda
lambda = 5; % параметр распределения Пуассона
poisson_random = poissrnd(lambda, 1000, 1);

% Генерация экспоненциального распределения с параметром lambda
lambda = 2; % параметр экспоненциального распределения
exponential_random = exprnd(lambda, 1000, 1);

% Генерация распределения Эрланга с параметрами k и lambda
k = 2; % параметр формы
lambda = 3; % параметр масштаба
erlang_random = gamrnd(k, lambda, 1000, 1);

% Генерация нормального распределения с параметрами mu и sigma
mu = 0; % среднее значение
sigma = 1; % стандартное отклонение
normal_random = mu + sigma * randn(1000, 1);

% Генерация распределения Вейбула с параметрами a и b
a = 1; % параметр формы
b = 2; % параметр масштаба
weibull_random = wblrnd(a, b, 1000, 1);

% Генерация логнормального распределения с параметрами mu и sigma
mu = 1; % среднее значение
sigma = 0.5; % стандартное отклонение
lognormal_random = lognrnd(mu, sigma, 1000, 1);

% Генерация распределения Парето с параметрами k и sigma
k = 2; % параметр формы
sigma = 1; % параметр масштаба
pareto_random = sigma * (rand(1000, 1)).^(-1/k);

% Отображение гистограмм для каждого распределени
figure;
histogram(poisson_random, 'Normalization', 'probability');
title('Распределение Пуассона');
xlabel('Значение');
ylabel('Частота');

figure;
histogram(exponential_random, 'Normalization', 'probability');
title('Экспонециальное распределение');
xlabel('Значение');
ylabel('Частота');

figure;
histogram(erlang_random, 'Normalization', 'probability');
title('Распределение Эрланга');
xlabel('Значение');
ylabel('Частота');

figure;
histogram(normal_random, 'Normalization', 'probability');
title('Нормальное распределение');
xlabel('Значение');
ylabel('Частота');

figure;
histogram(weibull_random, 'Normalization', 'probability');
title('Распределение Вейбула');
xlabel('Значение');
ylabel('Частота');

figure;
histogram(lognormal_random, 'Normalization', 'probability');
title('Логнормальное распределение');
xlabel('Значение');
ylabel('Частота');

figure;
histogram(pareto_random, 'Normalization', 'probability');
title('Распределение Паретто');
xlabel('Значение');
ylabel('Частота');

% Генерация равномерного распределения на интервале [a, b]
a = 0;
b = 1;
uniform_random = a + (b-a) * rand(1000, 1);
figure;
histogram(uniform_random, 'Normalization', 'probability');
title('Равномерное распределение');
xlabel('Значение');
ylabel('Частота');
ave = check(a,b,uniform_random);


