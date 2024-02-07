
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
    bits       : IN unsigned(3 DOWNTO 0);

    -- Salidas
    D_CNT      : OUT STD_LOGIC;
    DESP_D     : OUT STD_LOGIC;
    UART_DONE  : OUT STD_LOGIC;
    FIRST      : OUT STD_LOGIC;
    INC_8      : OUT STD_LOGIC := '0';
    RESET_8    : OUT STD_LOGIC
  );
END UART_UC;
ARCHITECTURE def_UART_UC OF UART_UC IS
  TYPE estado IS (e0, e1, e2, e3, E4);
  SIGNAL EP, ES : estado;
BEGIN

  PROCESS (EP, UART_IN, UART_TC, bits, ES)
    -- proceso que determina el ES
  BEGIN
    CASE EP IS
      WHEN e0 =>
        IF (UART_IN = '0') THEN
          ES <= e1;
        ELSE
          ES <= e0;
        END IF;

      WHEN e1 =>
        IF (UART_TC = '1') THEN
          ES <= e2;
        ELSE
          ES <= e1;
        END IF;
      WHEN e2 =>
        IF (UART_TC = '1') THEN
          ES <= e3;
        ELSE
          es <= e2;
        END IF;

      WHEN e3 =>
        IF (bits > x"8") THEN
          ES <= e4;
        ELSE
          ES <= e2;
        END IF;

      WHEN e4 =>
        IF (UART_IN = '1') THEN
          ES <= e0;
        ELSE
          ES <= e4;
        END IF;

      WHEN OTHERS =>
        ES <= ES;

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
  FIRST <= '1' WHEN (EP = e1 OR EP = e0) ELSE
    '0';
  D_CNT <= '1' WHEN (EP = e2 OR EP = e1) ELSE
    '0';
  DESP_D <= '1' WHEN (EP = e3) ELSE
    '0';
  RESET_8 <= '1' WHEN (EP = e0 AND UART_IN = '0') OR (EP = e1) ELSE
    '0';
  UART_DONE <= '1' WHEN (EP = e0) ELSE
    '0';
END def_UART_UC;