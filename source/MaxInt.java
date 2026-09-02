//
// MAX_VALUE + 1 == MIN_VALUE !?
//

// Questions:
//    Why are the MAX and MIN values set where they are?
//    What happens if you take the MAXINT value and add 1 ... mwhahahahaha
//    What happens if you take the MININT value and subtract 1 ... mwhahahahaha

public class MaxInt
{
	public static void main(String [] args) {
		int a,b;

		a= Integer.MAX_VALUE;
		b= Integer.MIN_VALUE;
		System.out.println("Max: "+a);
		System.out.println("Min: "+b);

		a++;
		System.out.println("Max+1: "+a);
		b--;
		System.out.println("Min-1: "+b);

		/*

		a= Integer.MAX_VALUE - 10;
		for (b=0; b<20; b++) {
			System.out.println(a);
			a++;
		}
		*/
	}
}
