Unit MKey;
{ Multiple Key reading unit }
{ 07-17-94 }

(*******************) Interface (*******************)
Const
   MAX_KEYS = 128; 
Var
   Keys         : Array[ 0..MAX_KEYS ] Of Boolean;
   
(*******************) Implementation (*******************)
Uses
   acrt,Dos;
Const
   KEYBOARD_PORT = $60;                      
   Release = 127; 
   
Var
  SaveKeyboard : Procedure;
  count : Byte;
  saveExitProc : pointer;
 
 
{$F+} 
Procedure NewKeyboard; Interrupt; 
Var 
   Key : Byte;             { Used to save which key was pressed or released } 
   
Begin 
   { PUSH the flags register before calling the old ISR } 
   Inline( $9C ); 
   { Call the old keyboard ISR }
   SaveKeyboard; 
   { DO NOT PUT A BREAKPOINT ABOVE THIS COMMENT --> KEYBOARD LOCKUP RESULTS }
   { Read which key was pressed (but not out of the keyboard buffer -- yet) }
   Key := Port[ KEYBOARD_PORT ]; 
   { Change the status of the key, depending on whether it was pressed or
   released. 

   Key AND RELEASE will clear the top bit (which indicates which key was
   pressed or released). 
   
   Key OR RELEASE will equal 127 ONLY if the top bit is clear (thus giving 
   TRUE for the key being pressed, and FALSE for a release). } 
   Keys[ (Key And Release) ] := ((Key Or Release) = Release); 
   
   { Empty the keyboard buffer (no keys have been read out of the keyboard 
   buffer). } 
   If KeyPressed Then getkey;
   
End; 
{$F-} 
 
Procedure mKeyDone; Far;
Begin
   ExitProc := saveExitProc;
   SetIntVec( $9, Addr( SaveKeyboard ) ); 
End;

(******************* Initialization *******************)
Begin
   saveExitProc := ExitProc;
   ExitProc := @mKeyDone;
   GetIntVec( $9, Addr( SaveKeyboard ) ); 
   SetIntVec( $9, @NewKeyboard ); 
   For Count := 0 To MAX_KEYS Do 
      Keys[ Count ] := False; 
End.
