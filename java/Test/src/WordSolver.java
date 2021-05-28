import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.Locale;


/**
 * Simple word solver against dictionary.
 * 
 * @author bjha
 *
 */
public class WordSolver {
	
	final List<String> dictionary;
	
	final List<String> qWords;
	
	
	public WordSolver(String df, String qf) throws IOException {
		
		dictionary = Files.readAllLines(Paths.get(df));
		
		Collections.sort(dictionary);
		
		qWords = Files.readAllLines(Paths.get(qf));
	}
	
	
	public void solve() {
		
		int wc = 0;
		boolean match = false;
		
		for(String qw : qWords) {
			
			wc++;
			
			qw = qw.trim().toLowerCase(Locale.ENGLISH);
			
			if (qw.length() > 1) {

				for (String dw : dictionary) {
					
					if( dw.isEmpty() || !Character.isAlphabetic(dw.charAt(0)))
						continue;

					dw = dw.trim().toLowerCase(Locale.ENGLISH);

					if (qw.length() == dw.length()) {

						match = false;

						for (int i = 0; i < qw.length(); i++) {

							if (qw.charAt(i) == '-')
								continue;

							match = qw.charAt(i) == dw.charAt(i);

							if (!match) {
								break;
							}
						}

						if (match) {
							System.out.println(wc + ". " + dw);
							break;
						}						
					}
				}
				
				if(!match) {
					System.out.println(wc + ". " + qw);
				}
			}
		}		
	}
}
