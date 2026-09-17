import java.util.Scanner;

public class MakeChange
{
	public static void main(String [] args)
	{
		// declare object of the Scanner class for keyboard input

		Scanner in = new Scanner(System.in);

		// declare variables

		int change;
		int serviceFee;
		int remainingChange;
		int remainingChangeDisplay;
		int quarters;
		int dimes;
		int nickels;
		int pennies;

		/* INPUT */

		System.out.print("Enter change (0-99): ");
		change = in.nextInt();

		/* PROCESS */

		// calculate service fee

		serviceFee = (int) change * 5 / 100;

		// calculate remaining change

		remainingChange = change - serviceFee;
		remainingChangeDisplay = remainingChange; // needed to store value of remaining change

		// calculate quarters

		quarters = remainingChange / 25;
		remainingChange = remainingChange % 25;

		// calculate dimes

		dimes = remainingChange / 10;
		remainingChange = remainingChange % 10;

		// calculate nickels

		nickels = remainingChange / 5;
		remainingChange = remainingChange % 5;

		// calculate pennies

		pennies = remainingChange / 1;
		remainingChange = remainingChange % 1;

		/* OUTPUT */

		System.out.println("Service fee : " + serviceFee);
		System.out.println("Remaining change : " + remainingChangeDisplay);
		System.out.println("Number of Quarters : " + quarters);
		System.out.println("Number of Dimes : " + dimes);
		System.out.println("Number of Nickels : "+ nickels);
		System.out.println("Number of Pennies : " + pennies);
	}
}
