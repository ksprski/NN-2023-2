function [xi, yi] = line_intersect(x1, y1, x2, y2, x3, y3, x4, y4)
  % Вычисляем коэффициенты уравнений прямых
  A1 = y2 - y1;
  B1 = x1 - x2;
  C1 = A1*x1 + B1*y1;
  A2 = y4 - y3;
  B2 = x3 - x4;
  C2 = A2*x3 + B2*y3;
  % Вычисляем точку пересечения
  det = A1*B2 - A2*B1;
  if det == 0
      xi = NaN;
      yi = NaN;
  else
      xi = (B2*C1 - B1*C2) / det;
      yi = (A1*C2 - A2*C1) / det;
  end
end
