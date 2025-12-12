partial def readSpacesAndLines (stream : IO.FS.Stream) (numBytes numWords numLines : Nat) : IO (Nat × Nat × Nat) := do
  let byte ← stream.read 1
  if byte.isEmpty then
        pure (numBytes, (numWords + 1), numLines)
  else
    let c := Char.ofNat byte[0]!.toNat
    if c.isWhitespace then
        if c == '\n' then
          readSpacesAndLines stream (numBytes + 1) (numWords) (numLines + 1)
        else
          readSpacesAndLines stream (numBytes + 1) (numWords) numLines
    else
        pure ((numBytes + 1), (numWords + 1), numLines)

partial def readBytes (stream : IO.FS.Stream) (numBytes numLines numWords : Nat) : IO (Nat × Nat × Nat) := do
  let byte ← stream.read 1
  if byte.isEmpty then
    pure (numBytes, numLines, numWords)
  else
    let c := Char.ofNat byte[0]!.toNat
    if c.isWhitespace then
      if c == '\n' then
        let (numBytes, newNumWords, numLines) ← readSpacesAndLines stream numBytes numWords numLines
        readBytes stream (numBytes + 1) (numLines + 1) newNumWords
      else
        let (numBytes, newNumWords, numLines) ← readSpacesAndLines stream numBytes numWords numLines
        readBytes stream (numBytes + 1) numLines newNumWords
    else
      readBytes stream (numBytes + 1) numLines numWords

def fmtProd (prod: (Nat × Nat × Nat)) :=
  match prod with
  | (bytes, lines, words) => "   " ++ toString lines ++ "    " ++ toString words ++ "    " ++ toString bytes

def main (args : List String) : IO Unit := do
  match args with
  | [] =>
    let stdin ← IO.getStdin
    let res ← readBytes stdin 0 0 0
    let stdout ← IO.getStdout
    stdout.putStrLn (fmtProd res)
  | ys =>
    let res ← ys.foldlM psFile (0,0,0)
    let stdout ← IO.getStdout
    stdout.putStrLn (fmtProd res)

  where psFile acc x :=  do
    let handle ← IO.FS.Handle.mk (System.FilePath.mk x) IO.FS.Mode.read
    let (bytes, lines, words) ← (readBytes (IO.FS.Stream.ofHandle handle) 0 0 0)
    match acc with
    | (bytes', lines', words') => pure (bytes + bytes', lines + lines', words + words')

#eval '\n'.isWhitespace

#print IO.FS.Handle

#eval System.FilePath.mk "test.txt"
