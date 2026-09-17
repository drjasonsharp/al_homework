public class IfDemo // class header
{
	public static void main(String[] args) // main method header
	{
		/********** section .data **********/

		// declare byte 8-bit strings (1 byte)

		// ENDL in Java is the newline escape character, \n, with null terminator \0, think println()
		String a = "x < 0: ";
		String b = "x >= z && x <= 20: ";
		String c = "x < 0 || x > y: ";
		String d = "!(x==0 && y==0): ";
		String e = "xd > yd: ";

		String True = "true";
		String False = "false";
		String xlab = "x: ";
		String ylab = "y: ";
		String zlab = "z: ";
		String xdlab = "xd: ";
		String ydlab = "yd: ";
		String zdlab = "zd: ";

		// declare doubleword 32-bit integers (4 bytes)

		int x = 5;
		int y = -5;
		int z = 0;

		// declare quadword 64-bit floating-point (8 bytes)

		double xd = 5.5;
		double yd = 5.49999999;
		double zd = 0.0;

		/********** section .bss **********/

		char mychar;		// reserve 1 byte (8-bits) for character value
		String mystr;		// reserve 80 consecutive bytes for string value (0-79)
		int myint;			// reserve 1 doubleword (32-bits/4 bytes) for integer value
		double mydouble;	// reserve 1 quadword (64-bits/8 bytes) for double value

		/********** section .text **********/

		// display labels

		System.out.print(xlab);
		System.out.print(x);
		System.out.println();
		System.out.print(ylab);
		System.out.print(y);
		System.out.println();
		System.out.print(zlab);
		System.out.print(z);
		System.out.println();
		System.out.print(xdlab);
		System.out.print(xd);
		System.out.println();
		System.out.print(ydlab);
		System.out.print(yd);
		System.out.println();
		System.out.print(zdlab);
		System.out.print(zd);
		System.out.println();
		System.out.println();

		// if (x < 0)

		System.out.print(a);

		if (x < 0)
			System.out.println(True);
		else
			System.out.println(False);

		// if (x >= z && x <= 20)

		System.out.print(b);

		if (x >= z && x <= 20)
			System.out.println(True);
		else
			System.out.println(False);

		// if (x < 0 || x > y)

		System.out.print(c);

		if (x < 0 || x > y)
			System.out.println(True);
		else
			System.out.println(False);

		// if (!(x==0 && y==0))

		System.out.print(d);

		if (!(x==0 && y==0))
			System.out.println(True);
		else
			System.out.println(False);

		// if (xd > yd)

		System.out.print(e);

		if (xd > yd)
			System.out.println(True);
		else
			System.out.println(False);

		System.exit(0);
	}
}