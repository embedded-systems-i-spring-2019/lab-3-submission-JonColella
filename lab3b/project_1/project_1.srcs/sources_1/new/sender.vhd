library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender is
Port (  reset, clk, enable, btn, ready : in std_logic;
        send : out std_logic;
        char : out std_logic_vector (7 downto 0) := (others => '0')
);
end sender;

architecture Behavioral of sender is

type state is (idle, busyA, busyB, busyC);
signal PS : state := idle;

type netid_array is array (0 to 5) of std_logic_vector(7 downto 0);
signal netid : netid_array := (x"106", x"99", x"50", x"48", x"48", x"52");

signal i : std_logic_vector (2 downto 0);

begin

process(clk)
begin
    if (rising_edge(clk)) then
        if (enable = '1') then
            if (reset = '1') then
                send <= '0';
                char <= "00000000";
                i <= "000";
                PS <= idle;
            else
            
            case PS is
                when idle =>
                    if (ready = '1' AND btn = '1') then
                        if (unsigned (i) < 6) then
                            send <= '1';
                            char <= netid(to_integer(unsigned(i)));
                            i <= std_logic_vector(unsigned(i) + 1);
                            PS <= busyA;
                        else
                            i <= "000";
                           PS <= idle;
                       
                       end if;
                       
                    end if;
                
                when busyA =>
                    PS <= busyB;
                
                when busyB =>
                    send <= '0';
                    PS <= busyC;
                
                when busyC =>
                    if (ready = '1' and btn = '0') then
                        PS <= idle;
                    else
                        PS <= busyC;
                    end if;
                
            end case;
            end if;
        end if;
    end if;
end process;

end Behavioral;
