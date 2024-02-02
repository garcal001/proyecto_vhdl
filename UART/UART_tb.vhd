LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY UART_tb IS

END;

ARCHITECTURE UART_tb_arch OF UART_tb IS
  SIGNAL UART_IN    : STD_LOGIC            := '1';
  SIGNAL UART_RESET : STD_LOGIC            := '1';
  SIGNAL clk        : STD_LOGIC            := '0';
  SIGNAL UART_OUT   : unsigned(7 DOWNTO 0) := "00000000";
  SIGNAL UART_DONE  : STD_LOGIC            := '0';

  COMPONENT UART
    PORT (
      -- input
      UART_IN    : IN STD_LOGIC;
      UART_RESET : IN STD_LOGIC;
      clk        : IN STD_LOGIC;

      -- output
      UART_OUT   : OUT unsigned(7 DOWNTO 0);
      UART_DONE  : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN -- comienzo de la arquitectura

  -- mapeo de las señales al modulo testeado
  DUT : UART
  PORT MAP(
    UART_IN    => UART_IN,
    UART_RESET => UART_RESET,
    clk        => clk,
    UART_OUT   => UART_OUT,
    UART_DONE  => UART_DONE
  );

  -- definicion reloj
  clk <= NOT clk AFTER 20 ns;

  -- cambios en el resto de entradas para comprobar el funcionamiento 
  PROCESS
  BEGIN
    --PRUEBA 1
    UART_IN    <= '1';
    UART_RESET <= '1';
    WAIT UNTIL clk 'event AND clk = '1';
    UART_RESET <= '0';
    WAIT UNTIL clk 'event AND clk = '1';
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '0';
    WAIT FOR 20 us;
    UART_IN <= '1';
    WAIT FOR 20 us;
    WAIT;
  END PROCESS;
END UART_tb_arch;