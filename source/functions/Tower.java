import java.util.Scanner;

public class Tower
{
	public static long count;
	public static void main(String [] args)
	{
		Scanner kb= new Scanner(System.in);
		long n;

		count= 0;
		/*
		System.out.print("Enter n: ");
		n= kb.nextInt();
*/

		for (int i=1; i<30; i++) {
			count= 0;
			tower(1,2,3,i);
			System.out.printf("%d disks took %d moves\n",i,count);
		}
	}

	public static void tower(long from, long to, long using, long n)
	{
		if (n==1)
			//count++;
			System.out.printf("Move from %d to %d\n",from,to);
		else
		{
			tower(from,using,to,n-1);
			tower(from,to,using,1);
			tower(using,to,from,n-1);
		}
	}
}

