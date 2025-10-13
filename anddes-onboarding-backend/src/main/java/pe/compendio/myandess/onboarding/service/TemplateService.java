package pe.compendio.myandess.onboarding.service;

import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class TemplateService {

    public String render(final String templateValue, final Map<String, String> params) {
        String value = templateValue;
        for (Map.Entry<String, String> entry : params.entrySet()) {
            value = value.replace(entry.getKey(), entry.getValue());
        }
        return value;
    }

}
