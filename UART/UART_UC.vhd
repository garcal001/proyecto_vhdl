
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- unsigned mota erabili ahal izateko

-- ping-pong jokoa. bi erabiltzaileen artean.
-- fitxategi honetan kontrol-unitatearen definizioa soilik ageri da.
entity UART_UC is
   port
      (
        -- Entradas
        clk:        in std_logic;
        UART_RESET: in std_logic;

		UART_IN:    in std_logic;
        UART_TC:    in std_logic;
 
		-- Salidas
        D_CNT:      out std_logic;
        DESP_D:     out std_logic;
        UART_DONE:   out std_logic

		
      );
end UART_UC;


architecture def_UART_UC OF UART_UC is
  type estado is (e0,e1,e2,e3);
  signal EP,ES	: estado;
  signal bits :     unsigned (2 downto 0); 
  	
begin

process (EP,UART_IN, UART_TC,bits)
-- proceso que determina el ES
begin
   case EP is
	when e0 =>	if (UART_IN='0') then ES <= e1; 
    end if ;
    
    when e1 => if (UART_TC = '1') then ES <= e2;
    end if; 

    when e2 => if (bits = "111") then ES <= e3;
                else 
                ES <= e1;
                bits <= bits + 1;  
    end if;

    when e3 => ES <= e0; 

    when others  => ES <= ES;

   end case;
end process;

-- proceso que actualiza el estado
process (CLK, UART_RESET)
begin
if UART_RESET = '1' then EP<= e0;
elsif (CLK'EVENT) and (CLK ='1') then EP <= ES ;
end if;
end process;


-- Señales de control

bits <= "000"   when (EP = e0); 
D_CNT <= '1'    when (EP = e1) else '0';
DESP_D <= '1'   when (EP = e2) else '0';
UART_DONE<= '1' when (EP = e3) else '0';



end def_UART_UC;


