library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_top is
    Port ( btn : in STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           TXD : in STD_LOGIC;
           RXD : out STD_LOGIC);
end uart_top;

architecture Behavioral of uart_top is

component clock_div
port(   clk_in : in std_logic;
        div : out std_logic);
end component;

component debounce
port(   clk : in std_logic;
        btn : in std_logic;
        dbnc: out std_logic);
end component;

component uart
port(   clk, en, send, rst : in std_logic;
        charSend : in std_logic_vector (7 downto 0);
        ready, tx : out std_logic);
end component;
        
component sender
port(   reset, clk, enable, btn, ready : in std_logic;
        send : out std_logic;
        char: out std_logic_vector (7 downto 0));
end component;

signal debounce_0, debounce_1 : std_logic;
signal send_internal : std_logic;
signal div : std_logic;
signal uart_ready : std_logic;
signal char_internal : std_logic_vector (7 downto 0);

begin

divider: clock_div
    port map (clk_in => clk, div => div);
    
debounceA : debounce
    port map (clk => clk, btn => btn(0), dbnc =>debounce_0);
    
debounceB : debounce
port map (clk => clk, btn => btn(1), dbnc =>debounce_1);

send : sender
port map (reset => debounce_0, clk => clk, enable => div, btn => debounce_1, ready => uart_ready, send => send_internal, char => char_internal);

uartA : uart
port map (clk => clk, en => div, send => send_internal, rst => debounce_0, charSend => char_internal, ready => uart_ready, tx => RXD);

end Behavioral;
