LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- unsigned mota erabili ahal izateko

ENTITY LCD_ctrl IS
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
END LCD_ctrl;

ARCHITECTURE def_LCD_ctrl OF LCD_ctrl IS

	COMPONENT LCD_ctrl_UC IS
		PORT (
			-- Entradas
			LT24_Init_Done : IN STD_LOGIC;
			OP_SETCURSOR   : IN STD_LOGIC;
			OP_DRAWCOLOUR  : IN STD_LOGIC;
			QDAT           : IN unsigned (2 DOWNTO 0);
			D0             : IN STD_LOGIC;
			D1             : IN STD_LOGIC;
			D2             : IN STD_LOGIC;
			D3             : IN STD_LOGIC;
			D4             : IN STD_LOGIC;
			D5             : IN STD_LOGIC;
			D6             : IN STD_LOGIC;
			ENDPIX         : IN STD_LOGIC;

			CLK            : IN STD_LOGIC;
			RESET_L        : IN STD_LOGIC;

			-- Salidas
			CL_LCD_DATA    : OUT STD_LOGIC;
			LD_CURSOR      : OUT STD_LOGIC;
			CL_DAT         : OUT STD_LOGIC;
			RSCOM          : OUT STD_LOGIC;
			LD_DRAW        : OUT STD_LOGIC;
			LD_2C          : OUT STD_LOGIC;
			LCD_WR_N       : OUT STD_LOGIC;
			LCD_CS_N       : OUT STD_LOGIC;
			RSDAT          : OUT STD_LOGIC;
			INC_DAT        : OUT STD_LOGIC;
			DEC_PIX        : OUT STD_LOGIC;
			DONE_CURSOR    : OUT STD_LOGIC;
			DONE_COLOUR    : OUT STD_LOGIC
		);
	END COMPONENT;

	-- Registros de posición
	SIGNAL RXCOL        : unsigned (7 DOWNTO 0);
	SIGNAL RYROW        : unsigned (8 DOWNTO 0);
	SIGNAL LD_CURSOR    : STD_LOGIC;

	-- Registro RGB
	SIGNAL RRGB         : unsigned (15 DOWNTO 0);

	-- Contador número de píxeles
	SIGNAL LD_DRAW      : STD_LOGIC;
	SIGNAL DEC_PIX      : STD_LOGIC;
	SIGNAL ENDPIX       : STD_LOGIC;
	SIGNAL CNT          : unsigned (16 DOWNTO 0);

	-- Contador data
	SIGNAL LD_2C        : STD_LOGIC;
	SIGNAL INC_DAT      : STD_LOGIC;
	SIGNAL CL_DAT       : STD_LOGIC;
	SIGNAL QDAT         : unsigned (2 DOWNTO 0);

	-- Mux data
	SIGNAL CL_LCD_DATA  : STD_LOGIC;
	SIGNAL QDAT_MUX_OUT : unsigned (15 DOWNTO 0);

	-- Demux qdat
	SIGNAL D0           : STD_LOGIC;
	SIGNAL D1           : STD_LOGIC;
	SIGNAL D2           : STD_LOGIC;
	SIGNAL D3           : STD_LOGIC;
	SIGNAL D4           : STD_LOGIC;
	SIGNAL D5           : STD_LOGIC;
	SIGNAL D6           : STD_LOGIC;

	-- RS "biestable"
	SIGNAL RSDAT        : STD_LOGIC;
	SIGNAL RSCOM        : STD_LOGIC;

BEGIN

	UC : LCD_ctrl_UC PORT MAP(
		LT24_Init_Done => LT24_Init_Done,
		OP_SETCURSOR   => OP_SETCURSOR,
		OP_DRAWCOLOUR  => OP_DRAWCOLOUR,
		QDAT           => QDAT,
		D0             => D0,
		D1             => D1,
		D2             => D2,
		D3             => D3,
		D4             => D4,
		D5             => D5,
		D6             => D6,
		ENDPIX         => ENDPIX,

		CLK            => CLK,
		RESET_L        => RESET_L,

		-- Salidas
		CL_LCD_DATA    => CL_LCD_DATA,
		LD_CURSOR      => LD_CURSOR,
		CL_DAT         => CL_DAT,
		RSCOM          => RSCOM,
		LD_DRAW        => LD_DRAW,
		LD_2C          => LD_2C,
		LCD_WR_N       => LCD_WR_N,
		LCD_CS_N       => LCD_CS_N,
		RSDAT          => RSDAT,
		INC_DAT        => INC_DAT,
		DEC_PIX        => DEC_PIX,
		DONE_CURSOR    => DONE_CURSOR,
		DONE_COLOUR    => DONE_COLOUR
	);

	-- Registro XCOL
	PROCESS (CLK, RESET_L)
	BEGIN
		IF RESET_L = '1' THEN
			RXCOL <= x"00";
			ELSIF CLK'event AND CLK = '1' THEN
			IF LD_CURSOR = '1' THEN
				RXCOL <= XCOL;
			END IF;
		END IF;
	END PROCESS;

	-- Registro YROW
	PROCESS (CLK, RESET_L)
	BEGIN
		IF RESET_L = '1' THEN
			RYROW <= "000000000";
			ELSIF CLK'event AND CLK = '1' THEN
			IF LD_CURSOR = '1' THEN
				RYROW <= YROW;
			END IF;
		END IF;
	END PROCESS;

	-- Registro RGB
	PROCESS (CLK, RESET_L)
	BEGIN
		IF RESET_L = '1' THEN
			RRGB <= x"0000";
			ELSIF CLK'event AND CLK = '1' THEN
			IF LD_DRAW = '1' THEN
				RRGB <= RGB;
			END IF;
		END IF;
	END PROCESS;

	-- Contador píxeles
	PROCESS (CLK, RESET_L)
	BEGIN
		IF RESET_l = '1' THEN
			CNT <= "00000000000000000";
			ELSIF CLK'event AND CLK = '1' THEN
			IF LD_DRAW = '1' THEN
				CNT <= NUMPIX;
				ELSIF DEC_PIX = '1' THEN
				CNT <= CNT - 1;
			END IF;
		END IF;
	END PROCESS;

	ENDPIX <= '1' WHEN CNT = "00000000000000000" ELSE
	'0';

	-- Contador data
	PROCESS (CLK, RESET_L)
	BEGIN
		IF RESET_L = '1' THEN
			QDAT <= "000";
			ELSIF CLK'event AND CLK = '1' THEN
			IF LD_2C = '1' THEN
				QDAT <= "110";
				ELSIF INC_DAT = '1' THEN
				QDAT <= QDAT + 1;
				ELSIF CL_DAT = '1' THEN
				QDAT <= "000";
			END IF;
		END IF;
	END PROCESS;

	-- Demux qdat
	PROCESS (QDAT)
	BEGIN
		D0 <= '0';
		D1 <= '0';
		D2 <= '0';
		D3 <= '0';
		D4 <= '0';
		D5 <= '0';
		D6 <= '0';
		CASE QDAT IS
			WHEN "000"  => D0  <= '1';
			WHEN "001"  => D1  <= '1';
			WHEN "010"  => D2  <= '1';
			WHEN "011"  => D3  <= '1';
			WHEN "100"  => D4  <= '1';
			WHEN "101"  => D5  <= '1';
			WHEN "110"  => D6  <= '1';
			WHEN OTHERS => D0 <= '0';
		END CASE;
	END PROCESS;

	-- Mux qdat
	PROCESS (QDAT, RXCOL, RYROW, RRGB)
	BEGIN
		CASE QDAT IS
			WHEN "000"  => QDAT_MUX_OUT  <= x"002A";
			WHEN "001"  => QDAT_MUX_OUT  <= x"0000";
			WHEN "010"  => QDAT_MUX_OUT  <= x"00" & RXCOL;
			WHEN "011"  => QDAT_MUX_OUT  <= x"002B";
			WHEN "100"  => QDAT_MUX_OUT  <= x"000" & "000" & RYROW(8);
			WHEN "101"  => QDAT_MUX_OUT  <= x"00" & RXCOL(7 DOWNTO 0);
			WHEN "110"  => QDAT_MUX_OUT  <= x"002C";
			WHEN "111"  => QDAT_MUX_OUT  <= RRGB;
			WHEN OTHERS => QDAT_MUX_OUT <= x"0000";
		END CASE;
	END PROCESS;

	LCD_DATA <= x"0000" WHEN CL_LCD_DATA = '1' ELSE
	QDAT_MUX_OUT;

	-- RS "biestable"
	PROCESS (CLK, RESET_L)
	BEGIN
		IF RESET_L = '1' THEN
			LCD_RS <= '0';
			ELSIF CLK'event AND CLK = '1' THEN
			IF RSDAT = '1' THEN
				LCD_RS <= '1';
				ELSIF RSCOM = '1' THEN
				LCD_RS <= '0';
			END IF;
		END IF;
	END PROCESS;
END def_LCD_ctrl;