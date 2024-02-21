LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY GENERAL IS
    PORT (
        -- Entradas 
        UART_IN       : IN unsigned(7 DOWNTO 0);
        UART_DONE     : IN STD_LOGIC;
        DONE_CURSOR   : IN STD_LOGIC;
        DONE_COLOUR   : IN STD_LOGIC;

        clk           : IN STD_LOGIC;
        RESET         : IN STD_LOGIC;
        INIT_DONE     : IN STD_LOGIC;

        -- Salidas 
        OP_SETCURSOR  : OUT STD_LOGIC;
        XCOL          : OUT unsigned(7 DOWNTO 0);
        YROW          : OUT unsigned (8 DOWNTO 0);
        OP_DRAWCOLOUR : OUT STD_LOGIC;
        RGB           : OUT unsigned(15 DOWNTO 0);
        NUM_PIX       : OUT unsigned (16 DOWNTO 0)
    );

END GENERAL;

ARCHITECTURE GENERAL_ARCH OF GENERAL IS
    COMPONENT GENERAL_UC IS
        PORT (
            -- Entradas
            DONE_CURSOR   : IN STD_LOGIC;
            DONE_COLOUR   : IN STD_LOGIC;
            TC_OFF        : IN STD_LOGIC;
            UART_IN       : IN unsigned(7 DOWNTO 0);
            UART_DONE     : IN STD_LOGIC;

            clk           : IN STD_LOGIC;
            RESET         : IN STD_LOGIC;
            INIT_DONE     : IN STD_LOGIC;

            -- Salidas
            RESET_BOLA    : OUT STD_LOGIC;
            --CL_LCD_DATA   : OUT STD_LOGIC;
            OP_SETCURSOR  : OUT STD_LOGIC;
            OP_DRAWCOLOUR : OUT STD_LOGIC;
            DEC_OFF       : OUT STD_LOGIC;

            REG_XCOL      : OUT unsigned(7 DOWNTO 0);
            REG_YROW      : OUT unsigned(8 DOWNTO 0);
            LD_POS        : OUT STD_LOGIC;
            RGB           : OUT unsigned(15 DOWNTO 0);
            NUM_PIX       : OUT unsigned(16 DOWNTO 0)
        );

    END COMPONENT;

    SIGNAL XCOL_DATA     : unsigned(7 DOWNTO 0) := x"64";       -- 100
    SIGNAL YROW_DATA     : unsigned(8 DOWNTO 0) := "0" & x"64"; -- 100
    SIGNAL YROW_OFF_DATA : unsigned(7 DOWNTO 0) := x"00";

    SIGNAL TC_OFF        : STD_LOGIC            := '0'; -- Cambiado por warning falta comprobar

    SIGNAL RGB2          : UNSIGNED(15 DOWNTO 0);
    SIGNAL RGBFONDO      : UNSIGNED(15 DOWNTO 0);
    -- Salidas
    SIGNAL RESET_BOLA    : STD_LOGIC;
    SIGNAL DEC_OFF       : STD_LOGIC;

    SIGNAL REG_XCOL      : unsigned(7 DOWNTO 0);
    SIGNAL REG_YROW      : unsigned(8 DOWNTO 0);
    SIGNAL LD_POS        : STD_LOGIC;

BEGIN
    UC : GENERAL_UC PORT MAP(
        -- Entradas
        DONE_CURSOR   => DONE_CURSOR,
        DONE_COLOUR   => DONE_COLOUR,
        TC_OFF        => TC_OFF,

        clk           => clk,
        RESET         => RESET,
        INIT_DONE     => INIT_DONE,
        UART_DONE     => UART_DONE,
        UART_IN       => UART_IN,

        -- Salidas
        RESET_BOLA    => RESET_BOLA,
        -- CL_LCD_DATA   => CL_LCD_DATA,
        OP_SETCURSOR  => OP_SETCURSOR,
        OP_DRAWCOLOUR => OP_DRAWCOLOUR,
        DEC_OFF       => DEC_OFF,

        REG_XCOL      => REG_XCOL,
        REG_YROW      => REG_YROW,
        -- RGB           => RGB,
        -- NUM_PIX       => NUM_PIX,
        LD_POS        => LD_POS
    );

    -- Contador YROW_OFF_DATA
    PROCESS (clk, RESET)
    BEGIN
        IF RESET = '1' THEN
            YROW_OFF_DATA <= X"00";

            ELSIF clk'event AND clk = '1' THEN
            IF RESET_BOLA = '1' THEN
                YROW_OFF_DATA <= x"64";
            END IF;
            IF YROW_OFF_DATA <= X"01" THEN
                TC_OFF           <= '1';
                ELSE
                TC_OFF <= '0';
                IF DEC_OFF = '1' THEN
                    YROW_OFF_DATA <= YROW_OFF_DATA - 1;
                END IF;
            END IF;

        END IF;
    END PROCESS;

    XCOL <= resize(120 - YROW_OFF_DATA * 120 / 100, 8)
    WHEN LD_POS = '1' ELSE
    x"00";
    YROW <= ("0" & YROW_OFF_DATA) + (x"6e" - 50) WHEN LD_POS = '1' ELSE
    "0" & x"00";

    PROCESS (clk, RESET)
    BEGIN

        IF RESET = '1' THEN
            RGB2     <= x"0000";
            RGBFONDO <= x"0000";
            ELSIF clk'event AND clk = '1' THEN
            CASE UART_IN IS
                WHEN "01110010" => RGB2 <= "1111100000000000";
                WHEN "01100111" => RGB2 <= "0000011111100000";
                WHEN "01100010" => RGB2 <= "0000000000011111";
                WHEN OTHERS     => RGB2     <= RGB2;
            END CASE;

            CASE UART_IN IS
                WHEN "01010010" => RGBFONDO <= "1111100000000000";
                WHEN "01000111" => RGBFONDO <= "0000011111100000";
                WHEN "01000010" => RGBFONDO <= "0000000000011111";
                WHEN OTHERS     => RGBFONDO     <= RGBFONDO;
            END CASE;
        END IF;
    END PROCESS;

    RGB <= RGB2 WHEN LD_POS = '1' ELSE
    RGBFONDO;
    NUM_PIX <= resize(2 * (YROW_OFF_DATA * 120 / 100), 17) WHEN LD_POS = '1' ELSE --
    "0" & X"0000";
END GENERAL_ARCH;