library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; --this library makes incrementing the vector easier

entity clock_div is
    Port ( clk_in : in STD_LOGIC;
           div : out STD_LOGIC);
end clock_div;

--divides a 125MHZ signal down to a 2Hz signal
architecture Behavioral of clock_div is
signal count: std_logic_vector (25 downto 0); --26 bits needed to count to 62,499,999
begin

process(clk_in) begin
    if (rising_edge(clk_in)) then
        if (count < 1085) then --baud rate
            count <= count + 1;
            div <= '0'; --output is low
        else
        count <= (others => '0');
        div <= '1'; --output is high
        count <= (others => '0');
        end if;
    end if;
end process;

end Behavioral;
