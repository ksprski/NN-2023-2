function is_inside = is_inside(point, polygon)
   % Преобразуем полигон в формат, подходящий для функции inpolygon
   %polygon = [polygon; polygon(1,:)];
   %display(polygon)
   % Проверяем, находится ли точка внутри полигона
   is_inside = inpolygon(point(1), point(2), polygon);
end