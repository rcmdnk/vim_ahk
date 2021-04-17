; https://autohotkey.com/board/topic/76062-ahk-l-how-to-get-callstack-solution/
FileReadLine( file, line ) {
  FileReadLine, data,% file,% line
  return data
}

CallStack( deepness = 5, printLines = 1 ) {
  if A_IsCompiled
    return
  loop,% deepness
  {
    ident .= A_Index = 1 ? "" : " "
    lvl := -1 - deepness + A_Index
    oEx := Exception( "", lvl )
    oExPrev := Exception( "", lvl - 1 )
    stack .= ( A_index = 1 ? "" : "`n" ) . ident 
    . "File '" oEx.file "', Line " oEx.line ", in " oExPrev.What
    . ( printLines ? ":`n" ident "     " FileReadLine( oEx.file, oEx.line ) : "" )
  }
  return stack
}

