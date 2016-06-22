import java.util.*;
import java.io.*;


// This is the class use to store all the local variables 
// within the recursive version of the fibonacci method
class ProgramFrame {
    int n;   // the value of the argument to the Fibonacci recursive algorithm
    int firstFib;   // the value of the first local variable
    int secondFib;  // the value of the second local variable
    int PC;  // the program counter
   
    // Constructor
    public ProgramFrame(int myN) {
	n = myN;
	firstFib = 0; // initialize firstFib to zero
	secondFib = 0; // initialize secondFib to zero
	PC = 1; // set program counter to one
    }

    // returns a String describing the content of the object
    public String toString() {
	return "ProgramFrame: n = " + n + " firstFib = " + firstFib + " secondFib = " + secondFib + " PC = " + PC;
    }
    
} // end of ProgramFrame class


class FibonacciNonRecursive {

    // This is the stack we will use to store the set of ProgramFrame mimicking the recursive calls
    static Stack<ProgramFrame> callStack;

    // Our non-recursive version of the fibonacci method, using a stack to mimic recursion
    static int fibonacci(int n) {
	
	// create the call stack
	callStack = new Stack<ProgramFrame>();
	
	// the initial program frame
	ProgramFrame current = new ProgramFrame(n); 

	// put that frame on the stack
	callStack.push(current);

	int returnValue = 0; // eventually, this will contain the answer

	// As long as our recursion stack is not empty...
	while ( !callStack.empty() ) {

	    // for debugging purposes
	    System.out.println(callStack);

	    // our base cases
	    if (callStack.peek().PC == 1) {  // this corresponds to the line "if (n<=1) return n;" of the pseudocode
		if (callStack.peek().n<= 1) {
		    returnValue = callStack.peek().n;

		    // we are done with that frame, so we pop it
		    callStack.pop(); 
		    
		    // if there is nothing left on the stack, we are done
		    if (callStack.empty()) break;
		    
		    // assigned the return value, currently stored in "returnValue", to either firstFib or secondFib, depending on PC
		    if (callStack.peek().PC == 2) callStack.peek().firstFib = returnValue; 
		    if (callStack.peek().PC == 3) callStack.peek().secondFib = returnValue; 
		    
		    // move PC up by one
		    callStack.peek().PC++;
		}
		else {// not in the base case, so we just move to the next line of the pseudocode.
		    callStack.peek().PC++;
		}
		continue;
	    }

	    // This corresponds to the recursive call firstFib=Fib(n-1)
	    if (callStack.peek().PC == 2) {
		
		// create a new program frame, corresponding to the recursive call
		current = new ProgramFrame(callStack.peek().n-1);
		callStack.push(current);
		continue;
	    }
	    
	    // This corresponds to the recursive call secondFib=Fib(n-2)
	    if (callStack.peek().PC == 3) {
		current = new ProgramFrame(callStack.peek().n-2);
		callStack.push(current);
		continue;
	    }

	    // This corresponds to the portion of the recursive algorithm where we add up and return firstFib + secondFib
	    if (callStack.peek().PC == 4) {
		returnValue =  callStack.peek().firstFib + callStack.peek().secondFib;

		callStack.pop();
		if (!callStack.empty()) {
		    // update firstFib or secondFib, depending on PC
		    if (callStack.peek().PC == 2) callStack.peek().firstFib  =  returnValue; 
		    if (callStack.peek().PC == 3) callStack.peek().secondFib  =  returnValue; 
		    // move PC up by one
		    callStack.peek().PC++;
		    continue;
		}
	    }
	}
	// we are done, just return returnValue
	return returnValue;
    }
    

    
    public static void main (String args[]) throws Exception {
	
	int n = 9;
	System.out.println("Fib(" + n + ")  =  " + fibonacci(n));

    }
}

	