package pe.compendio.myandess.onboarding.util;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.apache.tomcat.util.buf.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Converter
public class ListToStringConverter  implements AttributeConverter<List<String>, String> {
  @Override
  public String convertToDatabaseColumn(List<String> attribute) {
    if (attribute == null || attribute.isEmpty()) {
      return "";
    }
    return StringUtils.join(attribute, ',');
  }

  @Override
  public List<String> convertToEntityAttribute(String dbData) {
    if ((dbData == null) || dbData.trim().isEmpty()) {
      return new ArrayList<String>();
    }

    String[] data = dbData.split(",");
    return Arrays.asList(data);
  }
}
