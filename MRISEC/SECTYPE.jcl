//SECTYPE  JOB (40600000),CLASS=A,MSGCLASS=X,
//         MSGLEVEL=(1,1)    
//*------------------------------------------------------              
// EXEC PGM=IEBUPDTE,PARM=NEW                                          
//SYSPRINT DD SYSOUT=T                                                 
//SYSUT2   DD DSN=&&EXEC,DISP=(,PASS),UNIT=SYSDA,                      
// SPACE=(TRK,(5,5,2)),DCB=(LRECL=80,RECFM=FB)                         
//SYSIN    DD DATA,DLM='!!'                                            
./ ADD NAME=SECTYPE                                                    
/* REXX */                                                             
/*                                       */                            
/* THIS REXX WILL DISPLAY SECURITY PRODUCT TYPE RUNNING ON SYSTEM */   
/*  DISPLAY WILL BE "ACF2" "TOP SECRET" OR "RACF" */                   
/*                                       */                            
CVT      = C2D(STORAGE(10,4))                /* POINT TO CVT         */
CVTRAC   = C2D(STORAGE(D2X(CVT + 992),4))    /* POINT TO RACF CVT    */
RCVT     = CVTRAC                            /* USE RCVT NAME        */
RCVTID   = STORAGE(D2X(RCVT),4)              /* POINT TO RCVTID      */
                                             /* RCVT, ACF2, OR RTSS  */
SECNAM = RCVTID                              /* ACF2 SECNAME = RCVTID*/
IF RCVTID = 'RCVT' THEN SECNAM = 'RACF'      /* RCVT IS RACF         */
IF RCVTID = 'RTSS' THEN SECNAM = 'TOP SECRET'  /* RTSS IS TOP SECRET */
RACFVRM  = STORAGE(D2X(RCVT + 616),4)        /* RACF VER/REL/MOD     */
RACFVER  = SUBSTR(RACFVRM,1,1)               /* RACF VERSION         */
RACFREL  = SUBSTR(RACFVRM,2,2)               /* RACF RELEASE         */
RACFMOD  = SUBSTR(RACFVRM,4,1)               /* RACF MOD LEVEL       */
RACFLEV  = RACFVER || '.' || RACFREL || '.' || RACFMOD                 
SAY SECNAM                                                             
EXIT                                                                   
!!                                                                     
// EXEC PGM=IKJEFT01,DYNAMNBR=20                                       
//SYSPROC DD DSN=&&EXEC,DISP=(OLD,DELETE)                              
//SYSTSPRT DD SYSOUT=*                                                 
//SYSPRINT DD SYSOUT=*                                                 
//SYSTSIN DD *                                                         
%SECTYPE                                                               
/*