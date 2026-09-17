/*
	1!=1
	2!=2×1=22! = 2 \times 1 = 22!=2×1=2
	3!=3×2×1=63! = 3 \times 2 \times 1 = 63!=3×2×1=6
	4!=4×3×2×1=244! = 4 \times 3 \times 2 \times 1 = 244!=4×3×2×1=24
	5!=5×4×3×2×1=1205! = 5 \times 4 \times 3 \times 2 \times 1 = 1205!=5×4×3×2×1=120

	So, 5 factorial equals 120.
*/

public class LoopDemo // class header
{
	public static void main(String[] args) // main method header
	{
		// assume the labels count, n, and nfact are
		// all memory locations that hold 32-bit signed
		// integers

		int n = 5;
		int count = 0;
		int nfact = 0;

		System.out.println("Program starting . . .");
		System.out.println("n: " + n);
		System.out.println("count: " + count);
		System.out.println("nfact: " + nfact);

		count = 1;
		nfact = 1;

		// display initial values

		System.out.println("Loop starting . . .");

		System.out.println("count: " + count);

		while (count <= n)
		{
			nfact = nfact * count;
			count = count + 1;
			System.out.println("nfact: " + nfact);
			System.out.println("count: " + count);
		}

		System.out.println("Loop finished . . .");

		System.out.println("count: " + count);
		System.out.println("nfact: " + nfact);

		System.out.println("Program finished.");
	}
}