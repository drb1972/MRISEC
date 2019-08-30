/* rexx                                                       */
/* Use Case:  Automate MRI Security essentials loads via ZOWE */

drop lpar.
drop zosmf_profile.

path = config.txt 
count=0                           
file=.stream~new(path)     
do while file~lines<>0
   text=file~linein         
   if pos('*',text) > 0 then iterate
   count=count+1
   parse var text lpar.count zosmf_profile.count
end

lpar.0 = count 
zosmf_profile.0 = count

'rm .\MRISEC\output';'clear';'md .\MRISEC\output'; 'clear'  
say 'Starting process...'
do i = 1 to lpar.0 
   stem = rxqueue("Create"); call rxqueue "Set", stem 
   'bright zos-jobs submit local-file ".\MRISEC\SECTYPE.jcl" --rft string --zosmf-profile 'zosmf_profile.i'| rxqueue ' stem  
   pull output
   parse var output '":"' jobid '","' .
   call rxqueue "Delete", stem
   stem = rxqueue("Create"); call rxqueue "Set", stem 
   'bright zos-jobs view spool-file-by-id '||jobid||' 104 --zosmf-profile 'zosmf_profile.i'| rxqueue ' stem
   pull x; pull x;
   pull sectype
   call rxqueue "Delete", stem
   sectype = strip(sectype)
   say copies('=',40)
   say 'LPAR: 'lpar.i 'SECTYPE:' sectype
   stem = rxqueue("Create"); call rxqueue "Set", stem 
   select
         when sectype = 'TOP SECRET' then do
         'bright zos-jobs submit local-file ".\MRISEC\TSSJCL.jcl" --rft string --zosmf-profile 'zosmf_profile.i'| rxqueue ' stem  
         pull output
         parse var output '":"' jobid '","' .
         'bright zos-jobs view spool-file-by-id '||jobid||' 102 --zosmf-profile 'zosmf_profile.i'| rxqueue ' stem
         call write
      end
      when sectype = 'ACF2'       then do
         'bright zos-jobs submit local-file ".\MRISEC\ACF2JCL.jcl" --rft string --zosmf-profile 'zosmf_profile.i'| rxqueue ' stem  
         pull output
         parse var output '":"' jobid '","' .
         'bright zos-jobs view spool-file-by-id '||jobid||' ??? --zosmf-profile 'zosmf_profile.i'| rxqueue ' stem
         call write 
      end
      when sectype = 'RACF'       then do
         say 'Nothing to do here!!'
         iterate
      end
      otherwise do 
         say 'Error'
         Exit 8
      end
   end /* select */
   call rxqueue "Delete", stem
end
exit

write:
   ofile = lpar.i||'-'||sectype
   path = '.\MRISEC\output\'|| ofile
   say 'Writting 'path
   file=.stream~new(path) 
   file~open("both replace") 
   do queued()
      pull line
      file~lineout(line)
   end
   file~close
return