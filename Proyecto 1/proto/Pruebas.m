
% Se establece los numeros
num1 = 149;
num2 = 375;

% Counter
counter = 0;

% Resultado
resultado = 0;

% binarios
binario1 = dec2bin(num1)
binario2 = dec2bin(num2)

for n=0:7
  x = binario1(8 - n)
  
  if (x == '1')
    resultado = resultado + bitshift(num2, n)
  endif
endfor
