
-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
LIBRARY ieee;
USE ieee.std_logic_1164.ALL; -- libreria para tipo std_logic
USE ieee.numeric_std.ALL;    -- libreria para tipos unsigned/signed

-- Declaracion entidad
ENTITY LCD_Control_UC IS
  PORT (
    -- lista de entradas y salidas del modulo: reset, clk etc
    clk, reset                                                                    : IN STD_LOGIC;
    LCD_Init_Done, OP_SETCURSOR, OP_DRAWCOLOR, ENDPIX                             : IN STD_LOGIC;
    QDAT                                                                          : unsigned (2 DOWNTO 0);

    -- salidas
    DONE_CURSOR, DONE_COLOUR, LCD_CS_N, LCD_WR_N                                  : OUT STD_LOGIC;

    LD_CURSOR, LD_DRAW, DECPIX, CL_LCD_DATA, LD_2C, INC_DAT, CL_DAT, RSDAT, RSCOM : OUT STD_LOGIC
  );
END LCD_Control_UC;

-- Declaracion de la arquitectura correspondiente a la entidad
ARCHITECTURE arch_LCD_Control_UC OF LCD_Control_UC IS

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  TYPE tipo_estado IS (e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14);
  SIGNAL epres, esig : tipo_estado;
  -- SIGNAL LD_CURSOR, LD_DRAW, DECPIX, ENDPIX, CL_LCD_DATA, LD_2C, INC_DAT, CL_DAT, RSDAT, RSCOM : STD_LOGIC;
  -- SIGNAL QDAT        : unsigned (2 DOWNTO 0);

BEGIN -- comienzo de nombre_arquitectura

  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      epres <= e0;
    ELSIF clk'event AND clk = '1' THEN
      epres <= esig;
    END IF;
  END PROCESS;

  -- proceso combinacional que determina el valor de esig (estado siguiente)
  PROCESS (epres, LCD_Init_Done, OP_SETCURSOR, OP_DRAWCOLOR, ENDPIX, QDAT)
  BEGIN
    CASE epres IS
        -- una clausula when por cada estado posible
      WHEN e0 => IF LCD_Init_Done = '1' AND OP_SETCURSOR = '1' THEN
        esig <= e1;
      ELSIF LCD_Init_Done = '1' AND OP_SETCURSOR = '0' AND OP_DRAWCOLOR = '1' THEN
        esig <= e14;
      ELSE
        esig <= e0;
    END IF;
    WHEN e1 => esig <= e2;
    WHEN e2 => esig <= e3;
    WHEN e3 => esig <= e4;
    WHEN e4 => IF QDAT = "101" THEN
    esig <= e11;
  ELSIF QDAT = "010" THEN
    esig <= e12;
  ELSIF QDAT = "110" THEN
    esig <= e5;
  ELSE
    esig <= e13;
  END IF;
  WHEN e5 => esig <= e6;
  WHEN e6 => esig <= e7;
  WHEN e7 => esig <= e8;
  WHEN e8 => esig <= e9;
  WHEN e9 => IF ENDPIX = '1' THEN
  esig <= e10;
ELSE
  esig <= e6;
END IF;
WHEN e10 => esig <= e0;
WHEN e11 => esig <= e0;
WHEN e12 => esig <= e2;
WHEN e13 => esig <= e2;
WHEN e14 => esig <= e2;
END CASE;
END PROCESS;

-- una asignacion condicional para cada señal de control que genera la UC
CL_LCD_DATA <= '1' WHEN epres = e0 OR epres = e1 OR epres = e14 ELSE
  '0'; -- si es en logica positiva
CL_DAT <= '1' WHEN epres = e1 ELSE
  '0'; -- si es en logica negativa
LD_CURSOR <= '1' WHEN epres = e1 ELSE
  '0';
RSCOM <= '1' WHEN epres = e12 OR epres = e1 OR epres = e14 ELSE
  '0';
LCD_WR_N <= '0' WHEN epres = e2 OR epres = e6 ELSE
  '1';
LCD_CS_N <= '0' WHEN epres = e2 OR epres = e6 ELSE
  '1';
RSDAT <= '1' WHEN epres = e5 OR epres = e13 ELSE
  '0';
INC_DAT <= '1' WHEN epres = e5 OR epres = e12 OR epres = e13 ELSE
  '0';
LD_DRAW <= '1' WHEN epres = e14 ELSE
  '0';--or (epres=e6 and ENDPIX = '0') else '0';
DONE_COLOUR <= '1' WHEN epres = e10 ELSE
  '0';
DONE_CURSOR <= '1' WHEN epres = e11 ELSE
  '0';
LD_2C <= '1' WHEN epres = e14 ELSE
  '0';
DECPIX <= '1' WHEN epres = e7 ELSE
  '0';

END arch_LCD_Control_UC;