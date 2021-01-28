import java.util.ArrayList;
import java.util.List;

class SquareNode {
	int left;
	int center;
	int right;

	@Override
	public String toString() {
		return String.format("[%s,%s,%s]", left, center, right);
	}
}

public class SquareCircle {

	// private LinkedList<SquareNode> numbers = new LinkedList<SquareNode>();

	private final List<Integer> numbers = new ArrayList<Integer>();

	// ->
	// 4,32,17,19,30,6,3,13,12,24,25,11,5,31,18,7,29,20,16,9,27,22,14,2,23,26,10,15,1,8,28,21
	// -> 4
	public void layout(int max) {
		
		numbers.clear();

		if (max > 0) {

			int left = 0, current = 0, head =0;

			while (current++ < max) {
				
				if (isSquare(left + current)) {
					
					if(numbers.isEmpty())
						head = current;
					
					numbers.add(current);
					
					left = current;
					
					continue;
				}
				
				//rollover head
				if(isSquare( head + current)) {
					numbers.add( current );
					continue;
				}
			}
		}

		System.out.println(numbers);
	}

	//[4, 5, 11, 12, 14, 21, 22, 27, 32]
	//[1, 3, 6, 8, 10, 15, 21, 24, 28]
	public static boolean isSquare(int num) {

		if (num < 4 && num != 1)
			return false;

		double sqrt1 = Math.sqrt(num);
		double sqrt2 = Math.floor(sqrt1);
		// For perfect square both factors should be equal		
		if (Double.compare(sqrt1, sqrt2) == 0) {
			return true;
		}

		return false;
	}
}
