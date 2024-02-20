LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- unsigned mota erabili ahal izateko

-- ping-pong jokoa. bi erabiltzaileen artean.
-- fitxategi honetan kontrol-unitatearen definizioa soilik ageri da.
ENTITY GENERAL_UC IS
	PORT (
		-- Entradas
		DONE_CURSOR   : IN STD_LOGIC;
		DONE_COLOUR   : IN STD_LOGIC;
		TC_OFF        : IN STD_LOGIC;

		clk           : IN STD_LOGIC;
		RESET         : IN STD_LOGIC;
		INIT_DONE     : IN STD_LOGIC;
		UART_IN       : IN unsigned(7 DOWNTO 0);
		UART_DONE     : IN STD_LOGIC;

		-- Salidas
		RESET_BOLA    : OUT STD_LOGIC;
		OP_SETCURSOR  : OUT STD_LOGIC;
		OP_DRAWCOLOUR : OUT STD_LOGIC;
		DEC_OFF       : OUT STD_LOGIC;
		LD_POS        : OUT STD_LOGIC;

		REG_XCOL      : OUT UNSIGNED(7 DOWNTO 0);
		REG_YROW      : OUT UNSIGNED(8 DOWNTO 0);
		RGB           : OUT UNSIGNED(15 DOWNTO 0);
		NUM_PIX       : OUT UNSIGNED(16 DOWNTO 0)
	);
END GENERAL_UC;
ARCHITECTURE def_GENERAL_UC OF GENERAL_UC IS
	TYPE estado IS (e0, e1, e2, e3, e4, e5, e6);
	SIGNAL EP, ES : estado;

BEGIN

	PROCESS (EP, DONE_CURSOR, DONE_COLOUR, TC_OFF, INIT_DONE)
		-- proceso que determina el ES
	BEGIN
		CASE EP IS
			WHEN e0 =>
				IF (DONE_CURSOR = '1') THEN
					ES <= e1;
				ELSE
					ES <= e0;
				END IF;
			WHEN e1 =>
				IF (DONE_COLOUR = '1') THEN
					ES <= e2;
				ELSE
					ES <= e1;
				END IF;
			WHEN e2 =>
				ES <= e0;
			WHEN e3 =>
				IF (DONE_CURSOR = '1') THEN
					ES <= e3;
				ELSE
					ES <= e4;
				END IF;
			WHEN e4 =>
				IF (DONE_COLOUR = '1') THEN
					ES <= e5;
				ELSE
					ES <= e4;
				END IF;
			WHEN e5 =>
				ES <= e1;
				-- IF (TC_OFF = '1') THEN
				-- 	ES <= e5;
				-- ELSE
				-- 	ES <= e2;
				-- END IF;
			WHEN OTHERS =>
				ES <= e1;
		END CASE;
	END PROCESS;

	-- proceso que actualiza el estado
	PROCESS (clk, RESET)
	BEGIN
		IF RESET = '1' THEN
			EP <= e0;
		ELSIF (clk'EVENT) AND (clk = '1') THEN
			EP <= ES;
		END IF;
	END PROCESS;
	-- Señales de control

	-- RESET_BOLA <= '1' WHEN (EP = e0) ELSE
	-- 	'0';
	OP_SETCURSOR <= '1' WHEN (EP = e0) ELSE
		'0';
	OP_DRAWCOLOUR <= '1' WHEN (EP = e1) ELSE
		'0';
	DEC_OFF <= '1' WHEN (EP = e2) ELSE
		'0';
	-- DEC_OFF <= '1' WHEN (EP = e8) ELSE
	-- 	'0';
	-- LD_POS <= '1' WHEN (EP = e4 OR EP = e6 OR EP = e2 OR EP = E0) ELSE
	-- 	'0';

	-- REG_XCOL <= X"64" WHEN (EP = e3 OR EP = e4 OR EP = e5) ELSE
	-- 	x"00";
	-- REG_YROW <= "0" & X"64" WHEN (EP = e3 OR EP = e4 OR EP = e5) ELSE
	-- 	"0" & x"00";
END def_GENERAL_UC;