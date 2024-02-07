LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- unsigned mota erabili ahal izateko

-- ping-pong jokoa. bi erabiltzaileen artean.
-- fitxategi honetan kontrol-unitatearen definizioa soilik ageri da.
ENTITY LCD_ctrl_UC IS
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
END LCD_ctrl_UC;
ARCHITECTURE def_LCD_ctrl_UC OF LCD_ctrl_UC IS
	TYPE estado IS (e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14);
	SIGNAL EP, ES : estado;

BEGIN

	PROCESS (EP, LT24_Init_Done, OP_SETCURSOR, OP_DRAWCOLOUR, QDAT, ENDPIX)
		-- proceso que determina el ES
	BEGIN
		CASE EP IS
			WHEN e0 => IF (LT24_Init_Done = '0') THEN
			ELSIF (OP_SETCURSOR = '1') THEN
				ES <= e1;
			ELSIF (OP_DRAWCOLOUR = '1') THEN
				ES <= e14;
		END IF;

		WHEN e1 => ES <= e2;
		WHEN e2 => ES <= e3;
		WHEN e3 => ES <= e4;

		WHEN e4 =>
		IF (D0 = '1' OR D1 = '1' OR D3 = '1' OR D4 = '1') THEN
			ES <= e13;
		ELSIF (D6 = '1') THEN
			ES <= e5;
		ELSIF (D5 = '1') THEN
			ES <= e11;
		ELSIF (D2 = '1') THEN
			ES <= e12;
		END IF;

		WHEN e5 => ES <= e6;
		WHEN e6 => ES <= e7;
		WHEN e7 => ES <= e8;
		WHEN e8 => ES <= e9;

		WHEN e9 => IF (ENDPIX = '1') THEN
		ES <= e10;
	ELSE
		ES <= e6;
	END IF;
	WHEN e10 => ES <= e0;
	WHEN e11 => ES <= e0;
	WHEN e12 => ES <= e2;
	WHEN e13 => ES <= e2;
	WHEN e14 => ES <= e2;

END CASE;
END PROCESS;

-- proceso que actualiza el estado
PROCESS (CLK, RESET_L)
BEGIN
	IF RESET_L = '1' THEN
		EP <= e0;
	ELSIF (CLK'EVENT) AND (CLK = '1') THEN
		EP <= ES;
	END IF;
END PROCESS;
-- Señales de control

CL_LCD_DATA <= '1' WHEN (EP = e0 OR EP = e1 OR EP = e14) ELSE
	'0';
LD_DRAW   <= '1' WHEN (EP = e14);
LD_CURSOR <= '1' WHEN (EP = e0) ELSE
	'0';
CL_DAT <= '1' WHEN (EP = e0) ELSE
	'0';
RSCOM <= '1' WHEN (EP = e1 OR EP = e14 OR EP = e12) ELSE
	'0';
LD_2C <= '1' WHEN (EP = e14) ELSE
	'0';
LCD_WR_N <= '0' WHEN (EP = e2 OR EP = e6) ELSE
	'1';
LCD_CS_N <= '0' WHEN (EP = e2 OR EP = e6) ELSE
	'1';
RSDAT <= '1' WHEN (EP = e13 OR EP = e5) ELSE
	'0';
INC_DAT <= '1' WHEN (EP = e13 OR EP = e12 OR EP = e5) ELSE
	'0';
DONE_CURSOR <= '1' WHEN (EP = e11) ELSE
	'0';
DONE_COLOUR <= '1' WHEN (EP = e10) ELSE
	'0';
DEC_PIX <= '1' WHEN (EP = e7) ELSE
	'0';

END def_LCD_ctrl_UC;