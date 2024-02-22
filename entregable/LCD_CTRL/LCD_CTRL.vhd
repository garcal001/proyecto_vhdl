
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LCD_Control IS
  PORT (

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
ARCHITECTURE arch_LCD_Control OF LCD_Control IS
  TYPE tipo_estado IS (e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14);
  SIGNAL epres, esig                                                                           : tipo_estado;

  SIGNAL LD_CURSOR, LD_DRAW, DECPIX, ENDPIX, CL_LCD_DATA, LD_2C, INC_DAT, CL_DAT, RSDAT, RSCOM : STD_LOGIC;
  SIGNAL QDAT                                                                                  : unsigned (2 DOWNTO 0);
  SIGNAL RXCOL                                                                                 : unsigned (7 DOWNTO 0);
  SIGNAL RYROW                                                                                 : unsigned (8 DOWNTO 0);
  SIGNAL RRGB                                                                                  : unsigned (15 DOWNTO 0);

  SIGNAL muxout                                                                                : unsigned (15 DOWNTO 0);
  SIGNAL auxContPix                                                                            : unsigned (16 DOWNTO 0);

  COMPONENT LCD_Control_UC IS
    PORT (
      -- Entradas
      clk, reset                                                                    : IN STD_LOGIC;
      LCD_Init_Done, OP_SETCURSOR, OP_DRAWCOLOR, ENDPIX                             : IN STD_LOGIC;
      QDAT                                                                          : unsigned (2 DOWNTO 0);

      -- Salidas
      DONE_CURSOR, DONE_COLOUR, LCD_CS_N, LCD_WR_N                                  : OUT STD_LOGIC;
      LD_CURSOR, LD_DRAW, DECPIX, CL_LCD_DATA, LD_2C, INC_DAT, CL_DAT, RSDAT, RSCOM : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN -- comienzo de nombre_arquitectura
  UC : LCD_Control_UC PORT MAP(
    clk           => clk,
    reset         => reset,
    LCD_Init_Done => LCD_Init_Done,
    OP_SETCURSOR  => OP_SETCURSOR,
    OP_DRAWCOLOR  => OP_DRAWCOLOR,
    ENDPIX        => ENDPIX,
    QDAT          => QDAT,
    DONE_CURSOR   => DONE_CURSOR,
    DONE_COLOUR   => DONE_COLOUR,
    LCD_CS_N      => LCD_CS_N,
    LCD_WR_N      => LCD_WR_N,
    LD_CURSOR     => LD_CURSOR,
    LD_DRAW       => LD_DRAW,
    DECPIX        => DECPIX,
    CL_LCD_DATA   => CL_LCD_DATA,
    LD_2C         => LD_2C,
    INC_DAT       => INC_DAT,
    CL_DAT        => CL_DAT,
    RSDAT         => RSDAT,
    RSCOM         => RSCOM
  );
  muxout <= x"002A" WHEN (QDAT = "000") ELSE
    x"0000" WHEN (QDAT = "001") ELSE
    x"00" & RXCOL WHEN (QDAT = "010") ELSE
    x"002B" WHEN (QDAT = "011") ELSE
    x"000" & "000" & RYROW(8) WHEN (QDAT = "100") ELSE
    x"00" & RYROW(7 DOWNTO 0) WHEN (QDAT = "101") ELSE
    x"002C" WHEN (QDAT = "110") ELSE
    RRGB;

  LCD_DATA <= x"0000" WHEN CL_LCD_DATA = '1' ELSE
    muxout;
  PROCESS (clk, reset)
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

  PROCESS (clk, reset)
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

  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      RXCOL <= x"00";
    ELSIF clk'event AND clk = '1' THEN
      IF LD_CURSOR = '1' THEN
        RXCOL <= XCOL;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      RYROW <= x"00" & "0";
    ELSIF clk'event AND clk = '1' THEN
      IF LD_CURSOR = '1' THEN
        RYROW <= YROW;
      END IF;
    END IF;

  END PROCESS;

  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      RRGB <= x"0000";
    ELSIF clk'event AND clk = '1' THEN
      IF LD_DRAW = '1' THEN
        RRGB <= RGB;
      END IF;
    END IF;

  END PROCESS;

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

END arch_LCD_Control;