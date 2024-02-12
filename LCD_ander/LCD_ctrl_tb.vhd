LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY LCD_ctrl_tb IS

END;

ARCHITECTURE LCD_ctrl_tb_arch OF LCD_ctrl_tb IS
  -- entradas al modulo
  SIGNAL CLK            : STD_LOGIC              := '0';
  SIGNAL RESET_L        : STD_LOGIC              := '1';

  SIGNAL LT24_Init_Done : STD_LOGIC              := '0';
  SIGNAL OP_SETCURSOR   : STD_LOGIC              := '0';
  SIGNAL XCOL           : unsigned (7 DOWNTO 0)  := "00000000";
  SIGNAL YROW           : unsigned (8 DOWNTO 0)  := "000000000";
  SIGNAL OP_DRAWCOLOUR  : STD_LOGIC              := '0';
  SIGNAL RGB            : unsigned (15 DOWNTO 0) := "0000000000000000";
  SIGNAL NUMPIX         : unsigned (16 DOWNTO 0) := "00000000000000000";

  -- salidas del modulo
  SIGNAL DONE_CURSOR    : STD_LOGIC;
  SIGNAL DONE_COLOUR    : STD_LOGIC;
  SIGNAL LCD_CS_N       : STD_LOGIC;
  SIGNAL LCD_WR_N       : STD_LOGIC;
  SIGNAL LCD_RS         : STD_LOGIC;
  SIGNAL LCD_DATA       : unsigned (15 DOWNTO 0);
  COMPONENT LCD_ctrl
    PORT (
      -- Entradas
      LT24_Init_Done : IN STD_LOGIC;
      OP_SETCURSOR   : IN STD_LOGIC;
      XCOL           : IN unsigned (7 DOWNTO 0);
      YROW           : IN unsigned (8 DOWNTO 0);
      OP_DRAWCOLOUR  : IN STD_LOGIC;
      RGB            : IN unsigned (15 DOWNTO 0);
      NUMPIX         : IN unsigned (16 DOWNTO 0);

      CLK            : IN STD_LOGIC;
      RESET_L        : IN STD_LOGIC;

      -- Salidas
      DONE_CURSOR    : OUT STD_LOGIC;
      DONE_COLOUR    : OUT STD_LOGIC;
      LCD_CS_N       : OUT STD_LOGIC;
      LCD_WR_N       : OUT STD_LOGIC;
      LCD_RS         : OUT STD_LOGIC;
      LCD_DATA       : OUT unsigned (15 DOWNTO 0)
    );
  END COMPONENT;

BEGIN -- comienzo de la arquitectura

  -- mapeo de las señales al modulo testeado
  DUT : LCD_ctrl
  PORT MAP(
    -- Entradas
    LT24_Init_Done => LT24_Init_Done,
    OP_SETCURSOR   => OP_SETCURSOR,
    XCOL           => XCOL,
    YROW           => YROW,
    OP_DRAWCOLOUR  => OP_DRAWCOLOUR,
    RGB            => RGB,
    NUMPIX         => NUMPIX,

    CLK            => CLK,
    RESET_L        => RESET_L,

    -- Salidas
    DONE_CURSOR    => DONE_CURSOR,
    DONE_COLOUR    => DONE_COLOUR,
    LCD_CS_N       => LCD_CS_N,
    LCD_WR_N       => LCD_WR_N,
    LCD_RS         => LCD_RS,
    LCD_DATA       => LCD_DATA
  );
  -- definicion reloj
  CLK <= NOT CLK AFTER 20 ns;

  -- cambios en el resto de entradas para comprobar el funcionamiento 
  PROCESS
  BEGIN
    --PRUEBA 1

    RESET_L <= '1';
    WAIT UNTIL CLK 'event AND CLK = '1';

    RESET_L <= '0';
    WAIT UNTIL CLK 'event AND CLK = '1';

    XCOL         <= "00000001";
    YROW         <= "000000001";
    OP_SETCURSOR <= '1';

    WAIT UNTIL CLK 'event AND CLK = '1';

    LT24_Init_Done <= '1';
    WAIT UNTIL CLK 'event AND CLK = '1';
    XCOL         <= "00000000";
    YROW         <= "000000000";
    OP_SETCURSOR <= '0';

    WAIT FOR 1300 ns;

    RGB           <= x"001C";
    OP_DRAWCOLOUR <= '1';
    WAIT FOR 100 ns;

    OP_DRAWCOLOUR <= '0';

    WAIT FOR 500 NS;
    XCOL         <= "00000001";
    YROW         <= "000000001";
    OP_SETCURSOR <= '1';
    WAIT FOR 100 NS;
    OP_SETCURSOR <= '0';
    WAIT FOR 1300 ns;

    RGB           <= x"001C";
    OP_DRAWCOLOUR <= '1';
    WAIT FOR 100 ns;

    OP_DRAWCOLOUR <= '0';

    WAIT;
  END PROCESS;
END LCD_ctrl_tb_arch;