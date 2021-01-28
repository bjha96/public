import jsoncmp.JsonComparer;

public class Main {

	public static void main(String[] args) {

		//SOTest1 test1 = new SOTest1();
		//test1.run();
		//SquareCircle sc = new SquareCircle();
		//sc.layout(32);
		String baselineFile = "/home/bjha/eclipse-workspace/github/public/chrome_mandatory_policy.json";
		String givenFile = "/home/bjha/eclipse-workspace/github/public/chrome_mandatory_policy2.json";
		
		JsonComparer cmp = new JsonComparer( JsonComparer.readTextFile(baselineFile) );
		
		cmp.compare(JsonComparer.readTextFile(givenFile));
		
		System.out.println(cmp.getViolations());
	}
}
