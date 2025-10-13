package pe.compendio.myandess.onboarding.service;

import org.hibernate.sql.Template;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.junit.MockitoJUnitRunner;
import pe.compendio.myandess.onboarding.template.TemplateParamsBuilder;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@RunWith(MockitoJUnitRunner.class)
public class TemplateServiceTest {

    @InjectMocks
    private TemplateService templateService;

    @Test
    public void render() {
        String template = "hola $".concat(TemplateParamsBuilder.EMPLOYEE_NAME_KEY)
                .concat("<b><b>El curso inicia $").concat(TemplateParamsBuilder.START_DATE_ONBOARDING_KEY)
                .concat(" hasta $".concat(TemplateParamsBuilder.END_DATE_ONBOARDING_KEY));

        Map<String, String> params = new TemplateParamsBuilder()
                .setEmployeeName("Pedro")
                .setStartDateOnboarding("19/09/2025")
                .setEndDateOnboarding("26/09/2025")
                .setAddress("dirección")
                .build();

        String value = this.templateService.render(template, params);
        assertNotNull(value);
        assertTrue(value.contains("Pedro"));
        assertTrue(value.contains("19/09/2025"));
        assertTrue(value.contains("26/09/2025"));
    }
}