-- Mealy Machine (mealy.vhd)
-- Asynchronous reset, active low
------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog1 IS
PORT(
  x: in STD_ULOGIC;
  clk: in STD_ULOGIC;
  reset: in STD_ULOGIC;
  y: out STD_ULOGIC);
end;

ARCHITECTURE arch_mealy OF recog1 IS
  -- State declaration
  
  SIGNAL curState, nextState: std_LOGIC_vector(2 downto 0);
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(curState, x)
  BEGIN
    CASE curState IS
      WHEN "000" =>
        IF x='1' THEN 
          nextState <= "001";
        ELSE
          nextState <= "000";-- Fill in
          
        END IF;
        
      WHEN "001" =>
        IF x='0' THEN
          nextState <= "010"; -- Fill in
        ELSE
          nextState <= "001"; -- Fill in
        END IF;
      WHEN "010" => 
	IF x ='1' THEN
	  nextState <= "011";
	ELSE
	  nextState <= "000";
	END IF;
      WHEN "011" =>
	IF x = '0' THEN
	  nextState <= "000";
	ELSE 
	  nextState <= "001";
	END IF;
     WHEN OTHERS => 
	nextState <= "000";
      
    END CASE;
  END PROCESS; -- combi_nextState
  -----------------------------------------------------
  combi_out: PROCESS(curState, x)
  BEGIN
    y <= '0'; -- assign default value
    IF curState = "011" AND x='0' THEN
      y <= '1';
    END IF;
  END PROCESS; -- combi_output
  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= "000";
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
    END IF;
  END PROCESS; -- seq
  -----------------------------------------------------
END; -- arch_mealy
