/*
 * NOTE: This code is taken from
 * https://medium.com/swlh/branch-prediction-everything-you-need-to-know-da13ce05787e
 *
 * Run the program and note how long it took to complete. Then comment out the
 * Arrays.sort(data) line and run again. It will take about twice as long to
 * complete!
 *
 * From that article here are the basic rules of thumb:
 *
 * "As a general rule, most if not all Intel CPUs assume forward branches are not
 * taken the first time they see them. See Godboltâ€™s work."
 *
 * "After that, the branch goes into a branch prediction cache, and past behavior
 * is used to inform future branch prediction."
 *
 */
import java.util.Arrays;
import java.util.Random;

public class Main {
	public static void main(String[] args) {
		// Generate data
		int arraySize = 32768;
		int data[] = new int[arraySize];

		Random rnd = new Random(0);
		for (int c = 0; c < arraySize; ++c)
			data[c] = rnd.nextInt() % 256;

		// With this, the next loop runs faster
		//Arrays.sort(data);

		// Test
		long start = System.nanoTime();
		long sum = 0;

		for (int i = 0; i < 100000; ++i) {
		// Primary loop
		for (int c = 0; c < arraySize; ++c) {
			if (data[c] >= 128)
				sum += data[c];
			}
		}

		System.out.println((System.nanoTime() - start) / 1000000000.0);
		System.out.println("sum: " + sum);
	}
}