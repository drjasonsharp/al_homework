/**
 * Demonstrate recursvie n-factorial function.
 *
 * @author	Terry Sergeant
 *
*/

import java.util.Scanner;

public class NFact
{
	public static void main(String [] args)
	{
		Scanner kb= new Scanner(System.in);
		int n,ans;

		System.out.print("Enter value for n: ");
		n= kb.nextInt();

		ans= nfact(n);
		System.out.println("n! is: "+ans);
	}

	/**
	 * Recursively calculate n!.
	*/
	public static int nfact(int n)
	{
		if (n==0)
			return 1;
		else
			return n*nfact(n-1);
	}
}

