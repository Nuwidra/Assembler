% Instituto Tecnológico de Costa Rica
% Centro Académico Alajuela
% Esuela de Ingeniería en Computación
% IC-3101 Arquitectura de Computadores
% II Semestre 2020
% Prof.-Ing. Daniel Kohkemper, M.Sc.
%
% atan2 implementation file
% File:   ac_atan2.m
% Brief:  Implementation of atan2 function
% Input:  real_part coordinate, imag_part coordinate of complereal_part number
% Output: theta: angle of vector
%
% Grupo real_partreal_part
% Estudiante Jonathan Quesada Salas
% Estudiante Alejandro Loiaza Alvarado
% Estudiante Valeria Calderón Charpentier
%

% Variables en representacion Q

function [theta, octant] = ac_atan2(real_part, imag_part)
  
  theta  = 0;
  octant = 0;

  % Variables al cuadrado
  %real_partQ = cast(real_part, int16)
  %imag_partQ = cast(imag_part, int16)
  
  real_partCuadrado = real_part*real_part;
  imag_partCuadrado = imag_part*imag_part;

  % Numerador
  producto          = real_part*imag_part;

  % PI con la representacion Q
  PIQ15    = 102944;
  PI_2_Q15 = 51472;
  PI_4_Q15 = 25736;
  
  % Special angles
  if(real_part > 0 && imag_part == 0)
    octant = 0;
    theta  = 0;
    return;
  endif
  
  if(real_part < 0 && imag_part == 0)
    octant = 0;
    theta  = PIQ15;
    return;
  endif
  
  if(real_part == 0 && imag_part > 0)
    octant = 0;
    theta  = PI_2_Q15;
    return;
    
  endif
    if(real_part == 0 && imag_part < 0)
    octant = 0;
    theta  = -PI_2_Q15;
    return;
  endif
  
  if(real_part == 0 && imag_part==0)
    theta = disp("Undefined")
  endif
   real_partnegativo = 0;
  imag_partnegativo  = 0;

  if (real_part < 0)
    real_part         = abs(real_part);
    real_partnegativo = 1;
  endif

  if (imag_part < 0)
    imag_part         = abs(imag_part);
    imag_partnegativo = 1;
  endif
  
  if(real_part == imag_part && real_partnegativo > imag_partnegativo)
    octant = 0;
    theta  = (PI_4_Q15 + PI_2_Q15);
    return;
  endif
  if(real_part == imag_part && real_partnegativo < imag_partnegativo)
    octant = 0;
    theta  = -PI_4_Q15;
    return;
  endif

  if(real_part ==  imag_part && real_partnegativo == 1 && imag_partnegativo == 1)
    octant = 0;
    theta  = -(PI_4_Q15 + PI_2_Q15);
    return;
  endif
  if(real_part ==  imag_part && real_partnegativo == 0 && imag_partnegativo == 0)
    octant = 0;
    theta  = PI_4_Q15;
    return;
  endif
  
  denominador1 = bitshift((real_partCuadrado + bitshift(imag_partCuadrado,-2)+bitshift(imag_partCuadrado,-5)), -15)
  denominador2 = bitshift((imag_partCuadrado + bitshift(real_partCuadrado,-2)+bitshift(real_partCuadrado,-5)), -15)
  if (real_part > imag_part)
    if (real_partnegativo == 0)
      if (imag_partnegativo == 1)
       % 8 octant
       octant = 8
       
       theta  = round((producto)/denominador1)
      else
       % 1 octant
       octant = 1
       
       theta  = round((producto)/denominador1)
       
      endif
    endif
    if (real_partnegativo == 1)
      
      if (imag_partnegativo == 1)
        % 5 octant
        octant = 5
        
        theta  = -PIQ15+round((producto)/denominador1)
      else
        % 4 octant
        octant = 4

        theta  = PIQ15+round((producto)/denominador1)
      endif
    endif
  endif

  if (real_part < imag_part)
    if (imag_partnegativo == 0)
      
      if (real_partnegativo == 1)
        % 3 octant
        octant = 3
        
        theta  = PI_2_Q15 - round((producto)/denominador2)
      else
        %2 octant
        octant = 2
        
        % Angulo ESPECIAL
        if (real_part==0)
          theta = PI_2_Q15
        
        else 
          theta = PI_2_Q15 - round((producto)/denominador2)
        endif
      endif
    endif
    
    if (imag_partnegativo == 1) 
      if (real_partnegativo == 1)
        % 6 octant
        octant = 6

        theta  = -PI_2_Q15 - round((producto)/denominador2)
      else
        % 7 octant
        octant = 7

        theta  = -PI_2_Q15 - round((producto)/denominador2)
      endif
    endif 
  endif
end