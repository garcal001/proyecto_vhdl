
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- unsigned mota erabili ahal izateko

-- ping-pong jokoa. bi erabiltzaileen artean.
-- fitxategi honetan kontrol-unitatearen definizioa soilik ageri da.
ENTITY UART_UC IS
  PORT (
    -- Entradas
    clk        : IN STD_LOGIC;
    UART_RESET : IN STD_LOGIC;

    UART_IN    : IN STD_LOGIC;
    UART_TC    : IN STD_LOGIC;

    -- Salidas
    D_CNT      : OUT STD_LOGIC;
    DESP_D     : OUT STD_LOGIC;
    UART_DONE  : OUT STD_LOGIC
  );
END UART_UC;
ARCHITECTURE def_UART_UC OF UART_UC IS
  TYPE estado IS (e0, e1, e2, e3, E4);
  SIGNAL EP, ES : estado;
  SIGNAL bits   : unsigned (3 DOWNTO 0);
BEGIN

  PROCESS (EP, UART_IN, UART_TC)
    -- proceso que determina el ES
  BEGIN
    CASE EP IS
      WHEN e0 => IF (UART_IN = '0') THEN
        ES <= e1;
    END IF;

    WHEN e1 => bits <= x"0";
    ES              <= e2;

    WHEN e2 => IF (UART_TC = '1') THEN
    ES   <= e3;
    bits <= bits + 1;
  END IF;

  WHEN e3 =>
  IF (bits = x"9") THEN
    ES <= e4;
  ELSE
    ES <= e2;
  END IF;

  WHEN e4     => ES     <= e0;

  WHEN OTHERS => ES <= ES;

END CASE;
END PROCESS;

-- proceso que actualiza el estado
PROCESS (CLK, UART_RESET)
BEGIN
  IF UART_RESET = '1' THEN
    EP <= e0;
  ELSIF (CLK'EVENT) AND (CLK = '1') THEN
    EP <= ES;
  END IF;
END PROCESS;
-- Se�ales de control

-- bits  <= "000" WHEN (EP = e0);
D_CNT <= '1' WHEN (EP = e2) ELSE
  '0';
DESP_D <= '1' WHEN (EP = e3) ELSE
  '0';
UART_DONE <= '1' WHEN (EP = e4) ELSE
  '0';

END def_UART_UC;