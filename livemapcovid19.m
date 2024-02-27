% Загружаем данные о COVID-19 из файла CSV
data = webread('https://covid.ourworldindata.org/data/owid-covid-data.csv');

% Извлекаем данные о странах, датах и общем количестве случаев
countries = data.location; 
dates = data.date; 
cases = data.total_cases; 

% Создаем цветовую карту
color = jet(1000);

% Читаем географические данные из файла CSV
geo_data = readtable('average-latitude-longitude-countries.csv'); 

% Получаем список уникальных стран и удаляем некоторые из них
unique_countries = unique(countries);
unique_countries(13) = []; 
unique_countries(72) = []; 
num_countries = numel(unique_countries);

% Создаем диалоговое окно для выбора стран
[indx,tf] = listdlg('PromptString','Select up to 5 countries:',...
    'SelectionMode','multiple',...
    'ListString',unique_countries,...
    'ListSize',[300,300]);
selected_countries = unique_countries(indx);

% Ищем максимальное значение случаев среди выбранных стран
maxvalarr = [1];
for i=1:numel(selected_countries)
    maxvalarr = [maxvalarr max(table2array(data(strcmp(data.location,selected_countries{i}), 5)))];
end
maxval = max(maxvalarr);

% Создаем новую фигуру и отображаем карту мира
figure;
imagesc(color);
worldmap(selected_countries);
load coastlines;
geoshow(coastlat, coastlon, 'Color', 'black');
hold on;

% Инициализируем массивы для текста и легенды
txt = [];
legend_labels = cell(1, numel(selected_countries));
% Инициализируем массив для текстовых меток
text_handles = [];

% Добавляем названия стран на карту
for j = 1:numel(selected_countries)
    country = selected_countries{j};
    country_lat = geo_data.Latitude(strcmp(geo_data.Country, country));
    country_lon = geo_data.Longitude(strcmp(geo_data.Country, country));
    txt(j) = textm(country_lat, country_lon, sprintf('%s ', country), 'Color', 'black', 'FontSize', 8, 'HorizontalAlignment', 'center');
    set(txt(j), 'Layer', 'front');
end

% Проходим по данным и визуализируем случаи заболевания для каждой даты
for i = 1:10:numel(dates)
    date = dates(i);
    delete(text_handles);
    text_handles = [];
   
    for j = 1:numel(selected_countries)
        country = selected_countries{j};
        country_cases = data(strcmp(countries, country) & data.date == date, 5);
        country_lat = geo_data.Latitude(strcmp(geo_data.Country, country));
        country_lon = geo_data.Longitude(strcmp(geo_data.Country, country));

        country_cases = table2array(country_cases);
        nanIndices = isnan(country_cases);
        country_cases(nanIndices) = 0;
       
        % Рисуем маркер для каждой страны
        scatterm(country_lat, country_lon, floor(round(country_cases/maxval,4)*1000) + 1, color(min(floor(round(country_cases/maxval,4)*1000) + 1, 1000), :), 'filled');
        hold on;
        
        % Обновляем строки легенды
        legend_labels{j} = sprintf('%s: %d', country, country_cases);
        marker_color = color(min(floor(round(country_cases/maxval,4)*1000) + 1, 1000), :);
        legend_labels{j} = [legend_labels{j} ' ', sprintf('\\color[rgb]{%s}%s\\color{black}', num2str(marker_color), char(9679))];
    end
    hold off;

    % Обновляем заголовок и легенду
    title(['COVID-19 Cases on ' datestr(date)]);
    dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
    all_legend_labels = sprintf('%s\n', legend_labels{:});
    legend(dummyh,all_legend_labels,'Location', 'bestoutside');
    legend("boxoff");
    hold on;

    pause(0.1);
end