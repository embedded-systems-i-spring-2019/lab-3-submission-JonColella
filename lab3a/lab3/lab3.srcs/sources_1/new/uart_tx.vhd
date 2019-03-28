library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
Port (
        clk, en, send, rst  : in std_logic;
        char                : in std_logic_vector (7 downto 0);
        ready, tx           : out std_logic := '1'
        );
end uart_tx;

architecture fsm of uart_tx is

    type state is (idle, start, data);                                          --make a data type for states
    signal PS : state := idle;                                                  --define some states we will use 

    signal inputbuffer : std_logic_vector (7 downto 0) := (others => '0');      --the register captures 8 bits when triggered
    
    signal counter : natural := 0;           --a counter to remember which bit we're sending
begin

process (clk)
begin
    if (rising_edge(clk)) then
        
        if (rst = '1') then
            PS <= idle;
            inputbuffer <= (others => '0');
            counter <= 0;
        
        elsif (en = '1') then
            case PS is
            
                when idle =>                    --idle state, wait for the send signal
                    ready <= '1';               --ready remains 1
                    tx <= '1';
                    if (send = '1') then        --if it's time to start
                        PS <= start;            --go to the start state next clock
                        inputbuffer <= char;        --store the input to a register
                    else
                        PS <= idle;
                    end if;
                    
                    
                when start =>
                   
                    ready <= '0';
                    tx <= '0';               --busy sending data
                    counter <= 0; --clear the counter in preparation
                    PS <= data;                 --next clock starts sending data
                    
                when data =>
                    if counter < 8 then--if there are still bits to send
                        tx <= inputbuffer(counter); --send the next bit
                        counter <= counter +1;  --increment which bit to send
                    else
                    tx <= '1';                  --stop bit send
                    PS <= idle;                 --end transmission
                    end if;
                when others =>
                    PS <= idle;                 --idle on anything else happening
                    
            end case;
        end if;
    end if;
end process;

end fsm;
