LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

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
    SIGNAL YROW_OFF_DATA : unsigned(2 DOWNTO 0) := "000";

    SIGNAL TC_OFF        : STD_LOGIC            := '0'; -- Cambiado por warning falta comprobar

    -- Salidas
    SIGNAL RESET_BOLA    : STD_LOGIC;
    --SIGNAL CL_LCD_DATA   : STD_LOGIC;
    -- SIGNAL OP_SETCURSOR  : STD_LOGIC;
    -- SIGNAL OP_DRAWCOLOUR : STD_LOGIC;
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

        -- Salidas
        RESET_BOLA    => RESET_BOLA,
        -- CL_LCD_DATA   => CL_LCD_DATA,
        OP_SETCURSOR  => OP_SETCURSOR,
        OP_DRAWCOLOUR => OP_DRAWCOLOUR,
        DEC_OFF       => DEC_OFF,

        REG_XCOL      => REG_XCOL,
        REG_YROW      => REG_YROW,
        RGB           => RGB,
        NUM_PIX       => NUM_PIX,
        LD_POS        => LD_POS
    );

    XCOL <= XCOL_DATA;
    YROW <= YROW_DATA + YROW_OFF_DATA;

    -- Contador YROW_OFF_DATA
    PROCESS (clk, RESET)
    BEGIN
        IF RESET = '1' THEN
            YROW_OFF_DATA <= "101";

        ELSIF clk'event AND clk = '1' THEN
            IF DEC_OFF = '1' AND YROW_OFF_DATA > 0 THEN
                YROW_OFF_DATA <= YROW_OFF_DATA - 1;
            END IF;
            IF RESET_BOLA = '0' THEN
                YROW_OFF_DATA <= "101";
            END IF;
        END IF;
    END PROCESS;

    -- Registro XCOL
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            XCOL_DATA <= x"00";
        ELSIF CLK'event AND CLK = '1' THEN
            IF LD_POS = '1' THEN
                XCOL_DATA <= REG_XCOL;
            END IF;
        END IF;
    END PROCESS;

    -- Registro YROW
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            YROW_DATA <= "0" & x"00";
        ELSIF CLK'event AND CLK = '1' THEN
            IF LD_POS = '1' THEN
                YROW_DATA <= REG_YROW;
            END IF;
        END IF;
    END PROCESS;

END GENERAL_ARCH;