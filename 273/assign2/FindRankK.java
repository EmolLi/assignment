package median;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class FindRankK{

	public static void main(String[] args) {
		
		int a[] = {90,10,30,50,60,70,20,80,40,0};
	
		int[] list = new int[ a.length ];
		
		for (int i=0; i < a.length;  i++)
			list[i] = a[i];
		
		int maxrank = a.length-1;
		int rank =0;
		System.out.println("which rank item would you like? (" + 0 + " to " + maxrank + " ) : ");

		//  Here is how you read an integer from console in Java   =:0 
		
		String line = null;
		try {
		BufferedReader is = new BufferedReader(
				 new InputStreamReader(System.in));
        line = is.readLine();
        rank = Integer.parseInt(line);
		}
        catch (IOException e) {
        	      System.err.println("Unexpected IO ERROR: " + e);
        }
		System.out.println(findRankK(rank, list));
	}
	
	static int findRankK( int k, int[] list){
		 
		
		int i;
		int len = list.length; 
		
		//   create a buffer for the partitioned list

		int[] partitionedList = new int[len];
		i = 1;
		int low = 0;
		int high = len-1;
		int pivot  = list[0];

		//  Copy elements from list into the buffer, making L1, L2, L3.
		//  Elements smaller than the pivot go in the low part of the buffer.
		//  Elements larger than the pivot go in the high part of the buffer.
		//  Fill space in between with L2 (pivot).   		
		
		while (i < len){
			if (list[i] < pivot){
				partitionedList[low] = list[i];
				low++;
			}
			else if (list[i] > pivot){
				partitionedList[high] = list[i]; 
				high--;
			}
			i++;
		}
        i = low;
		while  (i <= high){
			partitionedList[i] = pivot ; 
			i++;
		}
		
		//   The partitionedList array will have L1,L2,L3 in 
		//   [0,low-1],[low,high], [high+1,len-1]
		//    Now make a new list to be used for the recursion.
		//   In the MIPS code, we will use the original array space
		//   to hold this list.
		
        if (k < low){
        	int[] newlist = new int[low];     		
			for (i = 0; i < low; i++)
            	newlist[i] = partitionedList[i];
			return findRankK(k, newlist);
		}
		else if (k <= high) 
			return pivot; 
		else{
        	int[] newlist = new int[len-(high+1)];     		
            for (i = high+1; i < len; i++)
            	newlist[i-(high+1)] =  partitionedList[i];
			return findRankK(k - (high+1), newlist);
		}
}


}