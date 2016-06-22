import java.util.*;
import java.io.*;


class ProgramFrame {
    int A[];
    int start;
    int stop;
    int mid;
    int PC;
    
    public ProgramFrame(int myA[], int myStart, int myStop) {
	A = myA;
	start = myStart;
	stop = myStop;
	mid = 0;
	PC = 1;
    }


    // returns a String describing the content of the object                                       \
    public String toString() {
        return "ProgramFrame: A = " + Arrays.toString(A) +", start = " + start + ", stop = " + stop + ", mid = "  + mid + ", PC = " + PC;
    }

}


class MergeSortNonRecursive {

    static Stack<ProgramFrame> callStack;

    // this implement the merge algorithm seen in class. Feel free to call it.
    public static void merge(int A[], int start, int mid, int stop) 
    {
	int index1 = start;
	int index2 = mid+1;
	int tmp[] = new int[A.length];
	int indexTmp = start;
	
	while ( indexTmp <= stop ) {
	    if ( index1 <= mid && (index2 > stop || A[index1] <= A[index2])) {
		tmp[indexTmp] = A[index1];
		index1++;
	    }
	    else {
		if (index2 <= stop && (index1 > mid || A[index2] <= A[index1])) {
		    tmp[indexTmp] = A[index2];
		    index2++;
		}
	    }
	    indexTmp++;
	}
	for (int i = start; i <= stop; i++) A[i] = tmp[i];
    }
    
    
    static void mergeSort(int A[]) {
	/* WRITE YOUR CODE HERE */

    }
    

    
    public static void main (String args[]) throws Exception {
	
	// just for testing purposes
	int myArray[] = {4,6,8,1,3,9,5,7,6,4,1,8,7,5};

	mergeSort(myArray);

	System.out.println("Sorted array is: " + Arrays.toString(myArray) );
    }
}

	