package jsoncmp;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Objects;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;


/**
 * Take a baseline JSON string and
 * compares it with a given JSON String
 * and reports the missing elements or those with different
 * values as violations.
 * 
 * @author bjha
 */
public class JsonComparer {
	
	private final JSONObject baselineObj;
	
	private final JSONObject violations;
	
	public JsonComparer(String baseline) {
		
		try {
			baselineObj= (JSONObject) new JSONParser().parse(baseline);
			violations = new JSONObject();
		} catch (ParseException e) {
			throw new RuntimeException("Bad baseline JSON: "+ baseline, e);
		}
	}
	
	
	public static String readTextFile(String filepath) {
		try {
			
			ByteArrayOutputStream buff = new ByteArrayOutputStream();
			Files.copy(Paths.get(filepath), buff);

			return buff.toString("UTF-8");
		} catch (IOException ioe) {
			throw new RuntimeException(filepath, ioe);
		}
	}
	
	
	public String getViolations() {
		return violations.toJSONString();
	}
	
	public boolean hasViolations() {
		return !violations.isEmpty();
	}
	
	
	@SuppressWarnings("unchecked")
	public void compare(String jsonStr) {

		JSONObject givenObj = null;
		
		try {
			givenObj = (JSONObject) new JSONParser().parse(jsonStr);
		} 
		catch (ParseException pe) {
			throw new RuntimeException("Bad given JSON: "+ jsonStr, pe);
		}
		
		
		for (Object property : baselineObj.keySet()) {

			Object baselineValue = baselineObj.get(property);
			Object givenValue = givenObj.get(property);
			
			if(Objects.equals(baselineValue, givenValue)) {
				continue;
			}
			
			if(baselineValue instanceof JSONArray ) {
				
				JSONArray baselineValues = (JSONArray) baselineValue;
				
				if(!baselineValues.isEmpty()) {
					
					JSONArray missingValues = new JSONArray();
					
					JSONArray givenValues = (JSONArray) givenValue;
					
					for(Object bv : baselineValues) {
						
						if(!givenValues.contains(bv)) {
							missingValues.add(bv);
						}
					}
					
					if(!missingValues.isEmpty()) {
						violations.put(property, missingValues);
					}
				}
			}
			else if(!String.valueOf(baselineValue).equalsIgnoreCase(String.valueOf(givenValue))) {
				violations.put(property, baselineValue);
			}
		}
	}
}
