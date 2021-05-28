package utils;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;


/**
 * Random password generator.
 * 
 * @author bjha
 */
public final class RandomText {
	
	private static final int MIN_PASSWORD_LENGTH = 4;
	private static final int MAX_PASSWORD_LENGTH = 1024;
	
	private final static char[] CHARS = "_-=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
	private final static char[] SPECIALS = "$%&!*^~#@".toCharArray();
	
	/**
	 * Random generator.
	 */
	private static Random rand;
	
	/**
	 * Get a random String with at least one numeric and one special character in it.
	 * 
	 * @param len length of random password to be created.
	 * 
	 * @return Random String
	 */
	public static String getRandomText(final int len) {

		if(len < MIN_PASSWORD_LENGTH || len > MAX_PASSWORD_LENGTH ) {
			throw new IllegalArgumentException("Bad length: " + len);
		}

		try {

			if(rand == null) {
				rand = SecureRandom.getInstanceStrong();
			}
		}
		catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e);
		}	

		StringBuilder sb = new StringBuilder(len);

		while(sb.length() < (len-2)){
			sb.append(CHARS[rand.nextInt(CHARS.length)]);
		}

		//Insert a random special char somewhere
		char sp = SPECIALS[rand.nextInt(SPECIALS.length)];
		sb.insert(rand.nextInt(sb.length()), sp);
		
		//Insert a random integer [0-9] somewhere.
		int nn = rand.nextInt(9);
		sb.insert(rand.nextInt(sb.length()), nn);

		return sb.toString();
	}
}
