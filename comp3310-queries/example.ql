/**
 * @name Call to System.out.println w/o corresponding call to Scanner.nextLine in loop
 * @kind problem
 * @problem.severity warning
 * @id java/example/empty-block
 */

import java

from LoopStmt loop, MethodAccess printlnCall, Method printlnMethod, Method nextLineMethod
where

    printlnCall.getMethod() = printlnMethod and

    // Check if printlnMethod is System.out.println
    printlnMethod.hasName("println") and
    printlnMethod.getDeclaringType().hasQualifiedName("java.io", "PrintStream") and
    
    // Check if method call is inside a loop
    loop.getAChild*() = printlnCall.getEnclosingStmt() and

    // Check if nextLineMethod is Scanner.nextLine
    nextLineMethod.hasName("nextLine") and
    nextLineMethod.getDeclaringType().hasQualifiedName("java.util", "Scanner")

    and not exists(
        MethodAccess nextLineCall 
        | nextLineCall.getMethod() = nextLineMethod
        | loop.getAChild*() = nextLineCall.getEnclosingStmt()
    )
    

select printlnCall, "Call to System.out.println in loop w/o call to Scanner.nextLine"
