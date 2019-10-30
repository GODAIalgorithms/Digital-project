
--Sorry that the name of file is wrong, this is a moore machine actually. 
------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog2 IS
PORT(
  x: in bit;
  clk: in bit;
  reset: in bit;
  y: out bit
  );

end;

ARCHITECTURE arch_my OF recog2 IS
  -- State declaration
  TYPE state_type IS (INIT, FIRST, SECOND, THIRD);  -- List your states here 	
  SIGNAL curState, nextState: state_type;
  SIGNAL count1,count2: integer;
  SIGNAL enable1_in:  BOOLEAN;
  SIGNAL enable2_in:  BOOLEAN;
  SIGNAL reset_c1, reset_c2: bit;


 
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(clk, curState, x, count1, count2)
  BEGIN 
	
    CASE curState IS
      WHEN INIT =>
	reset_c1 <= '1';
	reset_c2 <= '1';

        IF x = '0' THEN
	reset_c1 <= '0'; 
          nextState <= FIRST;

        ELSE
          nextState <= INIT;-- Fill in
          
        END IF;
        
      WHEN FIRST =>
	 enable1_in <= TRUE;
	 enable2_in <= FALSE;
        IF x ='1' AND count1 >= 15 THEN
          nextState <= SECOND;
 	reset_c1 <= '1';
	ElSIF x ='1'AND count1<15 THEN
	 nextState <= INIT;
	reset_c1<='1'; 
	 -- Fill in
        ELSIF x='0' THEN
          nextState <= FIRST; 
	
        END IF;

      WHEN SECOND =>
	reset_c2 <= '0';
      
	enable2_in <= TRUE;
	IF x='1' AND count2 =15 THEN
	  nextState <= THIRD;
		reset_c2<='1';
 	ELSIF x= '0'  THEN  
 	  nextState <= FIRST;
		reset_c2 <= '1';
		reset_c1 <= '0';
	  ELSIF x ='1' AND COUNT2 < 15 THEN 
	  enable2_in <= TRUE;
	  nextState <= SECOND;
	   

		
	END IF;


      WHEN THIRD =>
	IF x = '1' THEN
	  nextState <= INIT;
	ElSIF x='0' AND clk ='1' THEN
	  nextState <= FIRST;
	END IF;
	
     
      END CASE;
    
  END PROCESS; -- combi_nextState
  -----------------------------------------------------
  combi_out: PROCESS(curState)
  BEGIN
	y<='0';
     -- assign default value
    IF curState = THIRD THEN
      y <= '1';
    END IF;
  END PROCESS; -- combi_output
  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset <= '0' THEN
      curState <= INIT;
    ELSIF clk'EVENT AND clk ='1' THEN
      curState <= nextState;
    END IF;
  END PROCESS; -- seq
  ------------------------------------------------
  ----architecture struct of counter1 (15 bits)
 counter1_process: PROCESS(enable1_in, reset_c1, clk)

  BEGIN
  
 
   
	IF clk'EVENT and clk='1' THEN 
     		
	IF reset_c1 = '1' THEN
                  count1 <= 0;
		elsIF enable1_in = TRUE AND reset_c1='0' THEN -- enable
		      count1 <= count1 + 1;
	
	END IF;
END IF;
		END PROCESS;
     

 --------------------------------------------------
  -----architecture struct of counter2 (17 bits)
	
counter2_process: process(enable2_in, reset_c2, clk) 
BEGIN 
 
    

    IF clk'EVENT and clk ='1' THEN
  		
    IF reset_c2 = '1' THEN
      count2 <= 0;
    elsIF enable2_in = TRUE AND reset_c2 = '0' THEN -- enable
	count2 <= count2 + 1;
   
 	END IF;
END IF;



 END PROCESS;
------------------------------------------------------
 
  -----------------------------------------------------
END; -- arch_mealy
