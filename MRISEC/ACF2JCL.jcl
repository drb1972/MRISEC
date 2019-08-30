//ACF2JCL  JOB (40600000),CLASS=A,MSGCLASS=X,
//         MSGLEVEL=(1,1)    
//*-------------------------------------------------
//ACFBATCH EXEC PGM=ACFBATCH
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *       
 SHOW ALL              
 SHOW OMVS             
 SET LID               
 T TER                 
 LIST LIKE(-)          
 LIST IF(PSWD-EXP)     
 LIST IF(CANCEL)       
 LIST IF(SUSPEND)      
 LIST IF(SECURITY)     
 LIST IF(NON-CNCL)     
 LIST IF(READALL)      
 LIST IF(AUDIT)        
