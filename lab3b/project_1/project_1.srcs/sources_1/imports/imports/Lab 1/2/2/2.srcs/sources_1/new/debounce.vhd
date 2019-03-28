library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal shift_register : std_logic_vector (1 downto 0) := "00"; --initialize to zero
    signal register_output : std_logic;
    signal count : std_logic_vector (21 downto 0) := (others => '0'); --22 bits to get 2,500,000 clocks counted
begin

    process (clk) 
    begin
        if (rising_edge(clk)) then --ripple the signal up through the shift register
            --register_output <= shift_register(1); The shift register was not working
            --shift_register(1) <= shift_register(0); It does not seem neccessary
            --shift_register(0) <= btn; --input from the button
            
        end if;
    end process;

    process (clk)
    begin
        if (rising_edge(clk)) then
            if(btn = '1') then
                if (count < 2499999) then
                    count <= count + 1;
                    dbnc <= '0';
                else
                dbnc <= '1';
                end if;
            else
            count <= (others => '0');
            dbnc <= '0';
            end if;
        end if;
    end process;
end Behavioral;
