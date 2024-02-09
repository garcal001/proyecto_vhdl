LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DE10_Standard_proyecto IS
    PORT (
        -- CLOCK ----------------
        CLOCK_50     : IN STD_LOGIC;
        --  CLOCK2_50   : in    std_logic;
        --  CLOCK3_50   : in    std_logic;
        --  CLOCK4_50   : in    std_logic;
        -- KEY ----------------
        KEY          : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        --  KEY         : in    std_logic_vector(3 downto 0);
        -- LEDR ----------------
        LEDR         : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        -- SW ----------------
        --  SW          : in    std_logic_vector(9 downto 0);
        -- GPIO-LT24-UART ----------
        -- LCD --
        LT24_LCD_ON  : OUT STD_LOGIC;
        LT24_RESET_N : OUT STD_LOGIC;
        LT24_CS_N    : OUT STD_LOGIC;
        LT24_RD_N    : OUT STD_LOGIC;
        LT24_RS      : OUT STD_LOGIC;
        LT24_WR_N    : OUT STD_LOGIC;
        LT24_D       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- Touch --
        -- LT24_ADC_PENIRQ_N    : in    std_logic;
        -- LT24_ADC_DOUT        : in    std_logic;
        -- LT24_ADC_BUSY        : in    std_logic;
        -- LT24_ADC_DIN     : out   std_logic;
        -- LT24_ADC_DCLK        : out   std_logic;
        -- LT24_ADC_CS_N        : out   std_logic;
        -- UART --
        UART_RX      : IN STD_LOGIC
        -- GPIO default ----------------
        --  GPIO        : inout std_logic_vector(35 downto 0);
        -- CODEC Audio ----------------
        --  AUD_ADCDAT  : in    std_logic;
        --  AUD_ADCLRCK : in    std_logic;
        --  AUD_BCLK    : in    std_logic;
        --  AUD_DACDAT  : out   std_logic;
        --  AUD_DACLRCK : in    std_logic;
        --  AUD_XCK     : out   std_logic;
        -- I2C for Audio and Video-In ----------------
        --  FPGA_I2C_SCLK   : out   std_logic;
        --  FPGA_I2C_SDAT   : inout std_logic;
        -- SDRAM ----------------
        --  DRAM_ADDR   : out   std_logic_vector(12 downto 0);
        --  DRAM_BA     : out   std_logic_vector(1 downto 0);
        --  DRAM_CAS_N  : out   std_logic;
        --  DRAM_CKE    : out   std_logic;
        --  DRAM_CLK    : out   std_logic;
        --  DRAM_CS_N   : out   std_logic;
        --  DRAM_DQ     : inout std_logic_vector(15 downto 0);
        --  DRAM_LDQM   : out   std_logic;
        --  DRAM_RAS_N  : out   std_logic;
        --  DRAM_UDQM   : out   std_logic;
        --  DRAM_WE_N   : out   std_logic;
        -- 7-SEG ----------------
        --  HEX0    : out   std_logic_vector(6 downto 0);
        --  HEX1    : out   std_logic_vector(6 downto 0);
        --  HEX2    : out   std_logic_vector(6 downto 0);
        --  HEX3    : out   std_logic_vector(6 downto 0);
        --  HEX4    : out   std_logic_vector(6 downto 0);
        --  HEX5    : out   std_logic_vector(6 downto 0);
        -- ADC ----------------
        --  ADC_CS_N    : out   std_logic;
        --  ADC_DIN     : out   std_logic;
        --  ADC_DOUT    : in    std_logic;
        --  ADC_SCLK    : out   std_logic;
        -- HSMC default ------------------
        -- HSMC_CLKIN0      :in     std_logic;
        -- HSMC_CLKIN_N1    :in     std_logic;
        -- HSMC_CLKIN_N2    :in     std_logic;
        -- HSMC_CLKIN_P1    :in     std_logic;
        -- HSMC_CLKIN_P2    :in     std_logic;
        -- HSMC_CLKOUT0     :out    std_logic;
        -- HSMC_CLKOUT_N1   :out    std_logic;
        -- HSMC_CLKOUT_N2   :out    std_logic;
        -- HSMC_CLKOUT_P1   :out    std_logic;
        -- HSMC_CLKOUT_P2   :out    std_logic;
        -- HSMC_D           :inout  std_logic_vector(3 downto 0);
        -- HSMC_RX_D_N      :inout  std_logic_vector(16 downto 0);
        -- HSMC_RX_D_P      :inout  std_logic_vector(16 downto 0);
        -- HSMC_SCL         :out    std_logic;
        -- HSMC_SDA         :inout  std_logic;
        -- HSMC_TX_D_N      :inout  std_logic_vector(16 downto 0);
        -- HSMC_TX_D_P      :inout  std_logic_vector(16 downto 0);
        -- IRDA ----------------
        --  IRDA_RXD    : in    std_logic;
        --  IRDA_TXD    : out   std_logic;
        -- PS2 ----------------
        --  PS2_CLK     : in    std_logic;
        --  PS2_CLK2    : in    std_logic;
        --  PS2_DAT     : inout std_logic;
        --  PS2_DAT2    : inout std_logic;
        -- Video-In ----------------
        --  TD_CLK27    : in    std_logic;
        --  TD_DATA     : in    std_logic_vector(7 downto 0);
        --  TD_HS       : in    std_logic;
        --  TD_RESET_N  : out   std_logic;
        --  TD_VS       : in    std_logic;
        -- VGA ----------------
        --  VGA_B       : out   std_logic_vector(7 downto 0);
        --  VGA_BLANK_N : out   std_logic;
        --  VGA_CLK     : out   std_logic;
        --  VGA_G       : out   std_logic_vector(7 downto 0);
        --  VGA_HS      : out   std_logic;
        --  VGA_R       : out   std_logic_vector(7 downto 0);
        --  VGA_SYNC_N  : out   std_logic;
        --  VGA_VS      : out   std_logic;  : out   std_logic
    ); -- ***OJO*** ultimo de la lista sin ;

END;

ARCHITECTURE rtl OF DE10_Standard_proyecto IS
    SIGNAL clk, reset, reset_l : STD_LOGIC;
    SIGNAL bits_leds           : unsigned(7 DOWNTO 0);
    SIGNAL done_uart           : STD_LOGIC;
    SIGNAL UART_IN             : unsigned(7 DOWNTO 0);
    SIGNAL UART_DONE           : STD_LOGIC;
    SIGNAL DONE_CURSOR         : STD_LOGIC;
    SIGNAL DONE_COLOUR         : STD_LOGIC;

    SIGNAL OP_SETCURSOR        : STD_LOGIC;
    SIGNAL XCOL                : unsigned(7 DOWNTO 0);
    SIGNAL YROW                : unsigned (8 DOWNTO 0);
    SIGNAL OP_DRAWCOLOUR       : STD_LOGIC;
    SIGNAL RGB                 : unsigned(15 DOWNTO 0);
    SIGNAL NUM_PIX             : unsigned (16 DOWNTO 0);

    SIGNAL cs_n                : STD_LOGIC;
    SIGNAL wr_n                : STD_LOGIC;
    SIGNAL rs                  : STD_LOGIC;
    SIGNAL d                   : unsigned (15 DOWNTO 0);
    SIGNAL init_done           : STD_LOGIC;
    SIGNAL ciclos              : unsigned (18 DOWNTO 0);

    COMPONENT UART IS
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

    COMPONENT GENERAL IS
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
    END COMPONENT;

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

    -- LCD_setup
    COMPONENT LT24Setup
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
    END COMPONENT;

BEGIN
    UART_MAP : UART PORT MAP(
        UART_IN    => UART_RX,
        UART_RESET => reset,
        clk        => clk,

        -- output
        UART_OUT   => bits_leds,
        UART_DONE  => done_uart
    );

    GENERAL_MAP : GENERAL PORT MAP(
        -- Entradas 
        -- UART
        UART_IN       => bits_leds,
        UART_DONE     => done_uart,
        -- 
        DONE_CURSOR   => DONE_CURSOR,
        DONE_COLOUR   => DONE_COLOUR,

        clk           => clk,
        RESET         => reset,
        INIT_DONE     => init_done,

        -- Salidas 
        OP_SETCURSOR  => OP_SETCURSOR,
        XCOL          => XCOL,
        YROW          => YROW,
        OP_DRAWCOLOUR => OP_DRAWCOLOUR,
        RGB           => RGB,
        NUM_PIX       => NUM_PIX
    );

    LCD_CTRL_MAP : LCD_CTRL PORT MAP(
        -- Entradas
        LT24_Init_Done => init_done,
        OP_SETCURSOR   => OP_SETCURSOR,
        XCOL           => XCOL,
        YROW           => YROW,
        OP_DRAWCOLOUR  => OP_DRAWCOLOUR,
        RGB            => rgb,
        NUMPIX         => NUM_PIX,

        CLK            => clk,
        RESET_L        => reset,

        -- Salidas
        DONE_CURSOR    => DONE_CURSOR,
        DONE_COLOUR    => DONE_COLOUR,
        LCD_CS_N       => cs_n,
        LCD_WR_N       => wr_n,
        LCD_RS         => rs,
        LCD_DATA       => d
    );

    LCD_SETUP_MAP : LT24Setup PORT MAP(
        -- CLOCK and Reset_l ----------------
        clk            => clk,
        reset_l        => reset_l,

        LT24_LCD_ON    => LT24_LCD_ON,
        LT24_RESET_N   => LT24_RESET_N,
        LT24_CS_N      => LT24_CS_N,
        LT24_RS        => LT24_RS,
        LT24_WR_N      => LT24_WR_N,
        LT24_RD_N      => LT24_RD_N,
        LT24_D         => LT24_D,
        LT24_Init_Done => init_done,

        LT24_CS_N_Int  => cs_n,
        LT24_RS_Int    => rs,
        LT24_WR_N_Int  => wr_n,
        LT24_RD_N_Int  => '1',
        LT24_D_Int     => STD_LOGIC_VECTOR(d)

    );

    LEDR    <= done_uart & '0' & STD_LOGIC_VECTOR(bits_leds);

    clk     <= CLOCK_50;
    reset_l <= KEY(0);
    reset   <= NOT(KEY(0));
END rtl;