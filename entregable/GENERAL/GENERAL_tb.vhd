LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY GENERAL_tb IS

END;

ARCHITECTURE GENERAL_tb_arch OF GENERAL_tb IS
    SIGNAL UART_IN     : UNSIGNED(7 DOWNTO 0) := x"00";
    SIGNAL clk         : STD_LOGIC            := '0';
    SIGNAL UART_DONE   : STD_LOGIC            := '0';
    SIGNAL DONE_CURSOR : STD_LOGIC            := '0';
    SIGNAL DONE_COLOUR : STD_LOGIC            := '0';

    SIGNAL RESET       : STD_LOGIC            := '0';
    SIGNAL INIT_DONE   : STD_LOGIC            := '0';
    COMPONENT GENERAL
        PORT (
            -- input
            UART_IN       : IN UNSIGNED (7 DOWNTO 0);
            clk           : IN STD_LOGIC;
            UART_DONE     : IN STD_LOGIC;
            DONE_CURSOR   : IN STD_LOGIC;
            DONE_COLOUR   : IN STD_LOGIC;
            RESET         : IN STD_LOGIC;
            INIT_DONE     : IN STD_LOGIC;
            -- output
            OP_SETCURSOR  : OUT STD_LOGIC;
            OP_DRAWCOLOUR : OUT STD_LOGIC;

            XCOL          : OUT UNSIGNED (7 DOWNTO 0);
            YROW          : OUT UNSIGNED (8 DOWNTO 0);
            RGB           : OUT UNSIGNED (15 DOWNTO 0);
            NUM_PIX       : OUT UNSIGNED (16 DOWNTO 0)
        );
    END COMPONENT;

BEGIN -- comienzo de la arquitectura

    -- mapeo de las señales al modulo testeado
    DUT : GENERAL
    PORT MAP(
        INIT_DONE   => INIT_DONE,
        UART_IN     => UART_IN,
        clk         => clk,
        RESET       => RESET,
        UART_DONE   => UART_DONE,
        DONE_CURSOR => DONE_CURSOR,
        DONE_COLOUR => DONE_COLOUR

    );

    -- definicion reloj
    clk <= NOT clk AFTER 20 ns;

    -- cambios en el resto de entradas para comprobar el funcionamiento 
    PROCESS
    BEGIN
        --PRUEBA 1
        RESET <= '1';
        WAIT UNTIL clk 'event AND clk = '1';
        RESET <= '0';
        WAIT UNTIL clk 'event AND clk = '1';
        INIT_DONE <= '1';

        WAIT FOR 100 NS;
        DONE_CURSOR <= '1';
        WAIT FOR 20 NS;
        DONE_CURSOR <= '0';

        WAIT FOR 100 NS;
        DONE_COLOUR <= '1';
        WAIT FOR 20 NS;
        DONE_COLOUR <= '0';

        WAIT FOR 100 NS;
        DONE_CURSOR <= '1';
        WAIT FOR 20 NS;
        DONE_CURSOR <= '0';

        WAIT FOR 100 NS;
        DONE_COLOUR <= '1';
        WAIT FOR 20 NS;
        DONE_COLOUR <= '0';
        WAIT;
    END PROCESS;
END GENERAL_tb_arch;