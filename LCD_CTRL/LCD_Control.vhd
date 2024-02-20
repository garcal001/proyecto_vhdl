
-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
LIBRARY ieee;
USE ieee.std_logic_1164.ALL; -- libreria para tipo std_logic
USE ieee.numeric_std.ALL;    -- libreria para tipos unsigned/signed

-- Declaracion entidad
ENTITY LCD_Control IS
  PORT (
    -- lista de entradas y salidas del modulo: reset, clk etc
    clk, reset                                           : IN STD_LOGIC;
    LCD_Init_Done, OP_SETCURSOR, OP_DRAWCOLOR            : IN STD_LOGIC;
    XCOL                                                 : IN unsigned (7 DOWNTO 0);
    YROW                                                 : IN unsigned (8 DOWNTO 0);
    RGB                                                  : IN unsigned (15 DOWNTO 0);
    NUM_PIX                                              : IN unsigned (16 DOWNTO 0);
    DONE_CURSOR, DONE_COLOUR, LCD_CS_N, LCD_WR_N, LCD_RS : OUT STD_LOGIC;
    LCD_DATA                                             : OUT unsigned (15 DOWNTO 0)
  );
END LCD_Control;

-- Declaracion de la arquitectura correspondiente a la entidad
ARCHITECTURE arch_LCD_Control OF LCD_Control IS

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  TYPE tipo_estado IS (e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14);
  SIGNAL epres, esig                                                                           : tipo_estado;

  SIGNAL LD_CURSOR, LD_DRAW, DECPIX, ENDPIX, CL_LCD_DATA, LD_2C, INC_DAT, CL_DAT, RSDAT, RSCOM : STD_LOGIC;
  SIGNAL QDAT                                                                                  : unsigned (2 DOWNTO 0);
  SIGNAL RXCOL                                                                                 : unsigned (7 DOWNTO 0);
  SIGNAL RYROW                                                                                 : unsigned (8 DOWNTO 0);
  SIGNAL RRGB                                                                                  : unsigned (15 DOWNTO 0);
  --signal NUM_PIX: unsigned (16 downto 0);
  --SEÑALES AUXILIARES
  SIGNAL muxout                                                                                : unsigned (15 DOWNTO 0);
  SIGNAL auxContPix                                                                            : unsigned (16 DOWNTO 0);
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

----------------------------------------
------ UNIDAD DE PROCESO ---------------
----------------------------------------

-- codigo apropiado para cada uno de los componentes de la UP

-- multiplexor para seleccionar LCD_DATA 
-- al ser DAT de 4 bits lo ampliamos a 8 añadiendo 4 bits a 0 delante

muxout <= x"002A" WHEN (QDAT = "000") ELSE
  x"0000" WHEN (QDAT = "001") ELSE
  x"00" & RXCOL WHEN (QDAT = "010") ELSE
  x"002B" WHEN (QDAT = "011") ELSE
  x"000" & "000" & RYROW(8) WHEN (QDAT = "100") ELSE
  x"00" & RYROW(7 DOWNTO 0) WHEN (QDAT = "101") ELSE
  x"002C" WHEN (QDAT = "110") ELSE
  RRGB;
--MULTIPLEXOR QUE ELIGE SALIDA LCD_DATA 0 o lo que viene del otro multiplexor
LCD_DATA <= x"0000" WHEN CL_LCD_DATA = '1' ELSE
  muxout;
--Contador que nos dice la salida del multiplexor
PROCESS (clk, reset) -- si tiene señales asincronas, hay que incluirlas en la lista
BEGIN
  IF reset = '1' THEN
    QDAT <= "000";
  ELSIF clk'event AND clk = '1' THEN
    IF CL_DAT = '1' THEN
      QDAT <= "000";
    ELSIF LD_2C = '1' THEN
      QDAT <= "110";
    ELSIF INC_DAT = '1' THEN
      QDAT <= QDAT + 1;
    END IF;

  END IF;
END PROCESS;
--REGISTRO DE SEÑAL LCD_RS
PROCESS (clk, reset) -- si tiene señales asincronas, hay que incluirlas en la lista
BEGIN
  IF reset = '1' THEN
    LCD_RS <= '1';
  ELSIF clk'event AND clk = '1' THEN
    IF RSCOM = '1' THEN
      LCD_RS <= '0';
    ELSIF RSDAT = '1' THEN
      LCD_RS <= '1';
    END IF;
  END IF;
END PROCESS;
--REGISTRO DE LAS COLUMNAS
PROCESS (clk, reset) -- si tiene señales asincronas, hay que incluirlas en la lista
BEGIN
  IF reset = '1' THEN
    RXCOL <= x"00";
  ELSIF clk'event AND clk = '1' THEN
    IF LD_CURSOR = '1' THEN
      RXCOL <= XCOL;
    END IF;
  END IF;
END PROCESS;
--REGISTRO DE LAS LINEAS
PROCESS (clk, reset) -- si tiene señales asincronas, hay que incluirlas en la lista
BEGIN
  IF reset = '1' THEN
    RYROW <= x"00" & "0";
  ELSIF clk'event AND clk = '1' THEN
    IF LD_CURSOR = '1' THEN
      RYROW <= YROW;
    END IF;
  END IF;

END PROCESS;
-- REGISTRO DE LOS COLORES
PROCESS (clk, reset) -- si tiene señales asincronas, hay que incluirlas en la lista
BEGIN
  IF reset = '1' THEN
    RRGB <= x"0000";
  ELSIF clk'event AND clk = '1' THEN
    IF LD_DRAW = '1' THEN
      RRGB <= RGB;
    END IF;
  END IF;

END PROCESS;
-- CONTADOR DE LOS PIXELES
PROCESS (clk, reset)
BEGIN
  IF reset = '1'THEN
    auxContPix <= X"0000" & "0";
  ELSIF clk'event AND clk = '1' THEN
    IF LD_DRAW = '1'THEN
      auxContPix <= NUM_PIX;
    ELSIF DECPIX = '1'THEN
      auxContPix <= auxContPix - 1;
    END IF;
  END IF;
END PROCESS;
ENDPIX <= '1' WHEN (auxContPix = X"0000" & "0")
  ELSE
  '0';

-- los componentes asincronos se pueden describir de diversas formas
-- a veces es suficiente una sentencia de asignacion condicional

END arch_LCD_Control;