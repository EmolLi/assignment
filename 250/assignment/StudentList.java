// COMP 250 - ASSIGNMENT #1


// NAME: WRITE_YOUR_NAME_HERE
// STUDENT ID: WRITE_YOUR_STUDENT_ID_HERE


import java.io.*;    
import java.util.*;

class StudentList {
    int studentID[];
    int numberOfStudents;
    String courseName;
    
    //I have added another constructor here!!
    public StudentList(int size){
    	numberOfStudents=size;
    	studentID[]=new int[size];
    	courseName="";
    }

    // A constructor that reads a StudentList from the given fileName and assigns it the given courseName
    public StudentList(String fileName, String course) {
	String line;
	int tempID[]=new int[4000000]; // this will only work if the number of students is less than 4000000.
	numberOfStudents=0;
	courseName=course;
	BufferedReader myFile;
	try {
	    myFile = new BufferedReader(new FileReader( fileName ) );	

	    while ( (line=myFile.readLine())!=null ) {
		tempID[numberOfStudents]=Integer.parseInt(line);
		numberOfStudents++;
	    }
	    studentID=new int[numberOfStudents];
	    for (int i=0;i<numberOfStudents;i++) {
		studentID[i]=tempID[i];
	    }
	} catch (Exception e) {System.out.println("Can't find file "+fileName);}
	
    } //__2015__


    // This method produces a String containing the information about a StudentList.
    public String toString() {
	return("Course name: " + courseName + "\n" + "Number of students: " + numberOfStudents + "Student IDs:" + Arrays.toString(studentID));
    }


    //A copy constructor that copies the content original StudentList 
    // ranging from minStudentIndex to maxStudentIndex inclusively.
    // Used for sort();
    public StudentList(StudentList original, int minStudentIndex, int maxStudentIndex) {
	numberOfStudents=maxStudentIndex-minStudentIndex+1;
	courseName=original.courseName;
	studentID=new int[original.numberOfStudents];
	for (int i=minStudentIndex;i<=maxStudentIndex;i++) {
	    studentID[i-minStudentIndex]=original.studentID[i];
	}
    }
    

    // A constructor that generates a random student list of the given size and assigns it the given courseName
    public StudentList(int size, String course) {
	int IDrange=2*size;
	studentID=new int[size];
	boolean[] usedID=new boolean[IDrange];
	for (int i=0;i<IDrange;i++) usedID[i]=false;
	for (int i=0;i<size;i++) {
	    int t;
	    do {
		t=(int)(Math.random()*IDrange);
	    } while (usedID[t]);
	    usedID[t]=true;
	    studentID[i]=t;
	}
	courseName=course;
	numberOfStudents=size;
    }


    // Sorts a student list using the MergeSort algorithm
    public void sort() {
	if (numberOfStudents<=1) return;
	StudentList left=new StudentList(this, 0, numberOfStudents/2-1); // the left half of the list
	StudentList right=new StudentList(this, numberOfStudents/2, numberOfStudents-1); // the right half of the list
	left.sort(); // recursively sort the left and right halves
	right.sort();

	// now merge the two sorted halves
	int tmpIndex=0;
	int indexLeft=0;
	int indexRight=0;
	while (tmpIndex<numberOfStudents) {
	    if (indexRight>=right.numberOfStudents || 
		(indexLeft<left.numberOfStudents && left.studentID[indexLeft]<=right.studentID[indexRight])) {
		studentID[tmpIndex]=left.studentID[indexLeft];
		indexLeft++;
	    }
	    else {
		studentID[tmpIndex]=right.studentID[indexRight];
		indexRight++;
	    }
	    tmpIndex++;
	}
    }



    
    // Returns the number of students present in both lists L1 and L2
    public static int intersectionSizeNestedLoops(StudentList L1, StudentList L2) {
    	int inter=0;
	    for(int i=0;i<L1.numberOfStudents;i++){
	    	inner:
	    	for(int j=0;j<L2.numberOfStudents;j++){
	    		if(L1[i]==L2[j]){
	    			inter++;
	    			break inner;
	    		}
	    	}
	    }
	return inter;
    }
    
    
    // This algorithm takes as input a sorted array of integers called mySortedArray, the number of elements it contains, and the student ID number to look for
    // It returns true if the array contains an element equal to ID, and false otherwise.
    public static boolean myBinarySearch(int mySortedArray[], int numberOfStudents, int ID) {
    	int left =0;
    	int right =numberOfStudents-1;
    	while(left<=right){
    		int middle = (left+right)/2;
    		if(mySortedArray[middle]=ID) return true;
    		if(mySortedArray[middle]<ID) left=middle+1;
    		if(mySortedArray[middle]>ID) right=middle-1;
    	} 	
	return false;
    }
    
    
    public static int intersectionSizeBinarySearch(StudentList L1, StudentList L2) {
    	int inter =0;
    	L2.sort();
    	for(int i =0; i<L1.numberOfStudents; 1++){
    		if(myBInarySearch(L2,L2.numberOfStudents,L1[i])) inter++;
    	}
	return inter;
    }
    
    
    public static int intersectionSizeSortAndParallelPointers(StudentList L1, StudentList L2) {
    	int inter =0;
    	L1.sort();
    	L2.sort();
    	int a =0;
    	int b =0;
    	while(a<L1.numberOfStudents && b<L2.numberOfStudents){
    		if(L1[a]==L2[b]){
    			inter++;
    			a++;
    			b++;
    		}
    		else if(L1[a]<L2[b]){
    			a++;
    		}
    		else if(L1[a]>L2[b]){
    			b++;
    		}
    	}
	return inter;
    }
    
    
    public static int intersectionSizeMergeAndSort(StudentList L1, StudentList L2) {
    	int inter = 0;
    	//I feel that none of the constructor given is reasonable for this method, so I add another constructor at the very beginning of the code
    	StudentList L3 = new StudentList(L1.numberOfStudents+L2.numberOfStudents);
    		for(int a =0; a<L1.numberOfStudents; a++){
    			L3.studentID[a]=L1.studentID[a];
    		}
    		for(int b =0; b<L2.numberOfStudents; b++){
    			L3.studentID[L1.numberOfStudents+b]=L2.studentID[b];
    		}
    		L3.sort();
    		int i=0;
    		while(i<L3.numberOfStudents-1){
    			if(L3.studentID[i]==L3.studentID[i+1]){
    				inter++;
    				i+=2;
    			}
    			else i++;
    		}
    		return inter;
    	}
	

    
    
    
    
    /* The main method */
    /* Write code here to test your methods, and evaluate the running time of each.*/
    /* This method will not be marked */
    public static void main(String args[]) throws Exception {
	
	StudentList firstList;
	StudentList secondList;
	
	// This is how to read lists from files. Useful for debugging.
	
	//	firstList=new StudentList("COMP250.txt", "COMP250 - Introduction to Computer Science");
	//	secondList=new StudentList("MATH240.txt", "MATH240 - Discrete Mathematics");
	
	// get the time before starting the intersections
	long startTime = System.nanoTime();
	
	// repeat the process a certain number of times, to make more accurate average measurements.
	int numberRepetitions=1000;
	for (int rep=0;rep<numberRepetitions;rep++) {
	    
	    // This is how to generate lists of random IDs. 
	    // For firstList, we generate 16 IDs
	    // For secondList, we generate 16 IDs
	    
	    firstList=new StudentList(16 , "COMP250 - Introduction to Computer Science"); 
	    secondList=new StudentList(16 , "MATH240 - Discrete Mathematics"); 

	    // print the two lists, for future debugging purposes
	    System.out.println(firstList);
	    System.out.println(secondList);
	    
	    // run the intersection method
	    int intersection=StudentList.intersectionSizeBinarySearch(firstList,secondList);
	    System.out.println("The intersection size is: "+intersection);
	}
	
	// get the time after the intersection
	long endTime = System.nanoTime();
	
	
	System.out.println("Running time: "+ (float)(endTime-startTime)/numberRepetitions + " nanoseconds");
    }	
}


