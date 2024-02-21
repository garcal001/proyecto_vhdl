------------------------------------------------------
--  Project sample
--
-------------------------------------------------------
--
-- CLOCK_50 is the system clock.
-- KEY0 is the active-low system reset.
-- LCD withouth touch screen
-- 
---------------------------------------------------------------
--- Realizado por: G.A.
--- Fecha: 07/07/2021
--
--- Version: V0.0  Basic design with internal ROM
---------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--use ieee.numeric_std.all;
USE ieee.std_logic_arith.ALL;
USE work.romData_pkg.ALL;

ENTITY LT24Setup IS
  PORT (
    -- CLOCK and Reset_l ----------------
    clk            : IN STD_LOGIC;
    reset_l        : IN STD_LOGIC;

    LT24_LCD_ON    : OUT STD_LOGIC;
    LT24_RESET_N   : OUT STD_LOGIC;
    LT24_CS_N      : OUT STD_LOGIC;
    LT24_RS        : OUT STD_LOGIC;
    LT24_WR_N      : OUT STD_LOGIC;
    LT24_RD_N      : OUT STD_LOGIC;
    LT24_D         : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    LT24_CS_N_Int  : IN STD_LOGIC;
    LT24_RS_Int    : IN STD_LOGIC;
    LT24_WR_N_Int  : IN STD_LOGIC;
    LT24_RD_N_Int  : IN STD_LOGIC;
    LT24_D_Int     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    LT24_Init_Done : OUT STD_LOGIC
  );
END;

ARCHITECTURE rtl_0 OF LT24Setup IS

  COMPONENT romsinc
    PORT (
      clk    : IN STD_LOGIC;
      addr   : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      datout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT LT24InitReset IS
    PORT (
      clk          : IN STD_LOGIC;
      reset_l      : IN STD_LOGIC;

      Reset_Done   : OUT STD_LOGIC;

      LT24_RESET_N : OUT STD_LOGIC;
      LT24_LCD_ON  : OUT STD_LOGIC

    );
  END COMPONENT;

  COMPONENT LT24InitLCD IS
    PORT (
      clk             : IN STD_LOGIC;
      reset_l         : IN STD_LOGIC;

      LT24_Reset_Done : IN STD_LOGIC;

      LT24_Init_Done  : OUT STD_LOGIC;

      LT24_CS_N       : OUT STD_LOGIC;
      LT24_RS         : OUT STD_LOGIC;
      LT24_WR_N       : OUT STD_LOGIC;
      LT24_RD_N       : OUT STD_LOGIC;
      LT24_DATA       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;
  --------------------------------------------------
  ---------------------------Internal signals----------------------------
  SIGNAL LT24_Reset_Done    : STD_LOGIC; -- Inic Tic Counters
  SIGNAL tmp_LT24_RESET_N   : STD_LOGIC; -- tmp_LT24_RESET_N

  SIGNAL LT24_Init_Done_Tmp : STD_LOGIC; -- tmp_LT24_RESET_N
  SIGNAL Set_LT24_CS_N      : STD_LOGIC;
  SIGNAL Set_LT24_RS        : STD_LOGIC;
  SIGNAL Set_T24_WR_N       : STD_LOGIC;
  SIGNAL Set_LT24_RD_N      : STD_LOGIC;
  SIGNAL Set_LT24_D         : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
  DUT_RESET : LT24InitReset
  PORT MAP(
    clk          => clk,
    reset_l      => reset_l,
    Reset_Done   => LT24_Reset_Done,

    LT24_RESET_N => tmp_LT24_RESET_N,
    LT24_LCD_ON  => LT24_LCD_ON

  );

  LT24_RESET_N <= tmp_LT24_RESET_N;
  DUT_InitLCD : LT24InitLCD
  PORT MAP(
    clk             => clk,
    reset_l         => reset_l,
    LT24_Reset_Done => LT24_Reset_Done,

    LT24_Init_Done  => LT24_Init_Done_Tmp,

    LT24_CS_N       => Set_LT24_CS_N,
    LT24_RS         => Set_LT24_RS,
    LT24_WR_N       => Set_T24_WR_N,
    LT24_RD_N       => Set_LT24_RD_N,
    LT24_DATA       => Set_LT24_D
  );

  LT24_Init_Done <= LT24_Init_Done_Tmp;

  -- Proceso que registra las señales cada en cada flanco de reloj si  LT24_Init_Done está activado
  PROCESS (clk, reset_l)
  BEGIN
    IF reset_l = '0' THEN
      LT24_CS_N <= '0';
      LT24_RS   <= '1';
      LT24_WR_N <= '1';
      LT24_RD_N <= '1';
      LT24_D    <= (OTHERS => '0');
      ELSIF clk'event AND clk = '1' THEN
      IF LT24_Init_Done_Tmp = '0' THEN
        LT24_CS_N <= Set_LT24_CS_N;
        LT24_RS   <= Set_LT24_RS;
        LT24_WR_N <= Set_T24_WR_N;
        LT24_RD_N <= Set_LT24_RD_N;
        LT24_D    <= Set_LT24_D;
        ELSE
        LT24_CS_N <= LT24_CS_N_Int;
        LT24_RS   <= LT24_RS_Int;
        LT24_WR_N <= LT24_WR_N_Int;
        LT24_RD_N <= Set_LT24_RD_N;
        LT24_D    <= LT24_D_Int;
      END IF;
    END IF;
  END PROCESS;

  --------------------------------------------------
END rtl_0;