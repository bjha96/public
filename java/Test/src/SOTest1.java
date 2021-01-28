import java.util.Scanner;

//https://stackoverflow.com/questions/58191577/i-tried-a-lot-of-different-things-in-order-for-the-program-to-work-i-am-trying
public class SOTest1 {
	
	public void run() {
		try (Scanner keyboard = new Scanner(System.in)) {

			System.out.println("First int (length): ");
			int L = keyboard.nextInt();

			System.out.println("Second Int (height): ");
			int H = keyboard.nextInt();

			if ((L > 0 && H > 0) && (L < 21 && H < 21)) {

				for (int j = 0; j < H; j++) {
					for (int i = 0; i < L; i++) {
						System.out.print("*");
					}
					System.out.println();
				}

				return;
			}			
		}
		
		System.out.println("Bad input. Please enter values between [1-21].");
	}
}
