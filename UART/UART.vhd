LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- unsigned mota erabili ahal izateko

ENTITY UART IS
    PORT (
        -- input
        UART_IN    : IN STD_LOGIC;
        UART_RESET : IN STD_LOGIC;
        clk        : IN STD_LOGIC;

        -- output
        UART_OUT   : OUT unsigned(7 DOWNTO 0);
        UART_DONE  : OUT STD_LOGIC
    );
END UART;

ARCHITECTURE ART_UART OF UART IS
    COMPONENT UART_UC IS
        PORT (
            -- entradas
            UART_IN    : IN STD_LOGIC;
            UART_TC    : IN STD_LOGIC;

            clk        : IN STD_LOGIC;
            UART_RESET : IN STD_LOGIC;

            -- salidas
            D_CNT      : OUT STD_LOGIC;
            DESP_D     : OUT STD_LOGIC;
            UART_DONE  : OUT STD_LOGIC

        );
    END COMPONENT;

    SIGNAL UART_TC      : STD_LOGIC;
    SIGNAL D_CNT        : STD_LOGIC;
    SIGNAL DESP_D       : STD_LOGIC;
    SIGNAL UART_TC_HALF : STD_LOGIC;

    SIGNAL CNT          : unsigned (11 DOWNTO 0);

    SIGNAL UART_BITS    : unsigned (7 DOWNTO 0);
BEGIN
    UC : UART_UC PORT MAP(
        UART_IN      => UART_IN,
        UART_TC      => UART_TC,
        UART_TC_HALF => UART_TC_HALF,
        D_CNT        => D_CNT,
        DESP_D       => DESP_D,
        UART_DONE    => UART_DONE,
        clk          => clk,
        UART_RESET   => UART_RESET
    );

    --DESP_D <= UART_TC;
    -- contador
    PROCESS (clk, UART_RESET)
    BEGIN
        IF UART_RESET = '1' THEN
            CNT <= x"1F3"; -- 499

        ELSIF clk'event AND clk = '1' THEN
            IF CNT = "0" THEN
                CNT <= x"1F3";
            END IF;
            IF D_CNT = '1' AND CNT > 0 THEN
                CNT <= CNT - 1;

            END IF;
        END IF;
    END PROCESS;

    UART_TC <= '1' WHEN CNT = "0" ELSE
        '0';
    UART_TC_HALF <= '1' WHEN CNT = x"0F9" ELSE
        '0';

    -- Registo bits
    PROCESS (clk, UART_RESET)
    BEGIN
        IF UART_RESET = '1' THEN
            UART_OUT <= x"00";
        ELSIF clk'event AND clk = '1' THEN
            IF DESP_D = '1' THEN
                UART_BITS <= UART_IN & UART_BITS (7 DOWNTO 1);
                UART_OUT  <= UART_BITS;
            END IF;
        END IF;
    END PROCESS;

    -- UART_OUT <= UART_BITS;

END ART_UART;