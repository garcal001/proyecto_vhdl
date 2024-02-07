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
            bits       : IN unsigned(3 DOWNTO 0);

            -- salidas
            D_CNT      : OUT STD_LOGIC;
            DESP_D     : OUT STD_LOGIC;
            FIRST      : OUT STD_LOGIC;
            UART_DONE  : OUT STD_LOGIC;
            INC_8      : OUT STD_LOGIC;
            RESET_8    : OUT STD_LOGIC

        );
    END COMPONENT;

    SIGNAL UART_TC   : STD_LOGIC;
    SIGNAL D_CNT     : STD_LOGIC;
    SIGNAL DESP_D    : STD_LOGIC;

    SIGNAL CNT       : unsigned (15 DOWNTO 0);

    SIGNAL UART_BITS : unsigned (7 DOWNTO 0) := x"00";

    SIGNAL FIRST     : STD_LOGIC;
    SIGNAL cnt_dat   : unsigned (15 DOWNTO 0);

    SIGNAL INC_8     : STD_LOGIC;
    SIGNAL bits      : unsigned (3 DOWNTO 0);
    SIGNAL RESET_8   : STD_LOGIC;
BEGIN
    UC : UART_UC PORT MAP(
        UART_IN    => UART_IN,
        UART_TC    => UART_TC,
        D_CNT      => D_CNT,
        -- DESP_D     => DESP_D,
        UART_DONE  => UART_DONE,
        clk        => clk,
        UART_RESET => UART_RESET,
        FIRST      => FIRST,
        -- INC_8      => INC_8,
        bits       => bits,
        RESET_8    => RESET_8
    );

    cnt_dat <= x"1387" WHEN FIRST = '0' ELSE
        x"09c3";

    -- contador
    PROCESS (clk, UART_RESET)
    BEGIN
        IF UART_RESET = '1' THEN
            CNT <= cnt_dat; -- 4999

        ELSIF clk'event AND clk = '1' THEN
            IF CNT = "0" THEN
                CNT <= cnt_dat;
            END IF;
            IF D_CNT = '1' AND CNT > 0 THEN
                CNT <= CNT - 1;
            END IF;
        END IF;
    END PROCESS;

    DESP_D <= UART_TC;
    -- Registo bits
    PROCESS (clk, UART_RESET)
    BEGIN
        IF UART_RESET = '1' THEN
            UART_OUT <= x"00";
        ELSIF clk'event AND clk = '1' THEN
            IF DESP_D = '1' THEN
                -- UART_BITS <= UART_IN & UART_BITS SRL 1;
                UART_BITS <= UART_IN & UART_BITS (7 DOWNTO 1);
                UART_OUT  <= UART_BITS;
                -- UART_OUT             <= UART_IN & UART_BITS;
                -- UART_BITS(7)          <= UART_IN;
                -- UART_OUT <= UART_IN & shift_right(UART_BITS, 1) (6 DOWNTO 0);
                -- UART_OUT(7) <= UAcRT_IN;

            END IF;
        END IF;
    END PROCESS;
    UART_TC <= '1' WHEN CNT = "0" ELSE
        '0';

    INC_8 <= UART_TC;
    -- Contador bits
    PROCESS (clk, UART_RESET)
    BEGIN
        IF UART_RESET = '1' THEN
            bits <= x"0";
        ELSIF clk'event AND clk = '1' THEN

            IF RESET_8 = '1' THEN
                bits <= x"0";
            ELSIF INC_8 = '1' THEN
                bits <= bits + 1;
            END IF;
        END IF;
    END PROCESS;

    -- UART_OUT <= UART_BITS;

END ART_UART;