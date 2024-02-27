function ave = check(a,b,c)
% Создаем гистограмму
edges = linspace(a, b, 10); % 10 интервалов для гистограммы
figure;
histogram(c, edges, 'Normalization', 'probability');
xlabel('Значение');
ylabel('Частота');
title('Гистограмма равномерно распределенной величины');

% Проверка равномерности с помощью критерия хи-квадрат
counts = histcounts(c, edges); % Подсчет числа значений в каждом интервале
expected_counts = ones(size(counts)) * mean(counts); % Ожидаемое число значений в каждом интервале
[h_chi2, p_chi2] = chi2gof(c, 'Expected', expected_counts, 'Edges', edges);

% Вывод результатов
disp(['Результаты теста критерия хи-квадрат:']);
if h_chi2 == 0
    disp('H0 принимается (случайные числа равномерно распределены)');
else
    disp('H0 отклонена (случайные числа не равномерно распределены)');
end
disp(['p-значение: ' num2str(p_chi2)]);
% Проверка независимости с помощью теста на автокорреляцию
[acf, lags, bounds] = autocorr(c, 'NumLags', 20);

% Визуализация автокорреляций
figure;
stem(lags, acf, 'filled');
hold on;
plot([lags(1) lags(end)], [bounds(1) bounds(1)], 'r--', 'LineWidth', 2);
plot([lags(1) lags(end)], [-bounds(1) -bounds(1)], 'r--', 'LineWidth', 2);
xlabel('Лаг');
ylabel('Автокорреляция');
title('График автокорреляции');
grid on;
hold off;

% Вывод результатов
disp(['Результаты теста на автокорреляцию:']);
if max(abs(acf(2:end))) <= bounds(1)
    disp('H0 принимается (случайные числа независимы)');
else
    disp('H0 отклонена (случайные числа зависимы)');
end;
ave=a;
end