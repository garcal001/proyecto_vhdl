LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DE10_Standard_proyecto IS
    PORT (
        -- CLOCK ----------------
        CLOCK_50 : IN STD_LOGIC;
        --  CLOCK2_50   : in    std_logic;
        --  CLOCK3_50   : in    std_logic;
        --  CLOCK4_50   : in    std_logic;
        -- KEY ----------------
        KEY      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        --  KEY         : in    std_logic_vector(3 downto 0);
        -- LEDR ----------------
        --  LEDR        : out   std_logic_vector(9 downto 0);
        -- SW ----------------
        --  SW          : in    std_logic_vector(9 downto 0);
        -- GPIO-LT24-UART ----------
        -- LCD --
        -- LT24_LCD_ON  : out   std_logic;
        -- LT24_RESET_N : out   std_logic;
        -- LT24_CS_N        : out   std_logic;
        -- LT24_RD_N        : out   std_logic;
        -- LT24_RS          : out   std_logic;
        -- LT24_WR_N        : out   std_logic;
        -- LT24_D           : out   std_logic_vector(15 downto 0);
        -- Touch --
        -- LT24_ADC_PENIRQ_N    : in    std_logic;
        -- LT24_ADC_DOUT        : in    std_logic;
        -- LT24_ADC_BUSY        : in    std_logic;
        -- LT24_ADC_DIN     : out   std_logic;
        -- LT24_ADC_DCLK        : out   std_logic;
        -- LT24_ADC_CS_N        : out   std_logic;
        -- UART --
        --  UART_RX     : in    std_logic;
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

BEGIN
    clk     <= CLOCK_50;
    reset_l <= KEY(0);
    reset   <= NOT(KEY(0));
END rtl;