import static org.junit.Assert.*;
import org.junit.*;
import java.util.Arrays;
import java.util.List;

class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}



public class TestListExamples {
  public class containsCharacter implements StringChecker {
      char character;
      public containsCharacter (char character) {
          this.character = character;
      }

      @Override
      public boolean checkString(String s) {
          for (int i = 0; i < s.length(); ++i) {
              if (s.charAt(i) == character) {
                  return true;
              }
          }

          return false;
      }
  }

  @Test(timeout = 500)
  public void testMergeRightEnd() {
    List<String> left = Arrays.asList("a", "b", "c");
    List<String> right = Arrays.asList("a", "d");
    List<String> merged = ListExamples.merge(left, right);
    List<String> expected = Arrays.asList("a", "a", "b", "c", "d");
    assertEquals(expected, merged);
  }

  @Test
    public void filterTest () {
        List<String> input1 = 
            Arrays.asList(new String[]{"Apple", "Banana", "Carrot", "Dog"});
        StringChecker checkForA = new containsCharacter('a');
        
        String[] expected = {"Banana", "Carrot"};
        assertArrayEquals(expected, ListExamples.filter(input1, checkForA).toArray());
    }

    @Test
    public void mergeTest() {
        List<String> input1 = 
            Arrays.asList(new String[]{"Apple", "Carrot"});
        List<String> input2 = 
            Arrays.asList(new String[]{"Banana", "Dog"});
        
        List<String> expected1 = Arrays.asList(new String[]{"Apple", "Banana", "Carrot", "Dog"});
        List<String> merged = ListExamples.merge(input1, input2);

        for (int i = 0; i < expected1.size(); ++i) {
            assertEquals(expected1.get(i), merged.get(i));
        }
    }

    
}
