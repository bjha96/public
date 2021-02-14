package utils;

/**
 * ROT13 encryption.
 * 
 * {@link https://en.wikipedia.org/wiki/ROT13}
 * 
 * @author bjha
 *
 */
public class Rot13Cipher {

	private static final int ROTATE_BY = 13;

	public static String obfuscate(String data) {

		if (data != null) {

			StringBuilder sb = new StringBuilder();

			for (char ch : data.toCharArray()) {

				if (ch >= 'a' && ch <= 'm')
					ch += ROTATE_BY;
				else if (ch >= 'A' && ch <= 'M')
					ch += ROTATE_BY;
				else if (ch >= 'n' && ch <= 'z')
					ch -= ROTATE_BY;
				else if (ch >= 'N' && ch <= 'Z')
					ch -= ROTATE_BY;

				sb.append(ch);
			}

			return sb.toString();
		}

		return data;
	}
}
