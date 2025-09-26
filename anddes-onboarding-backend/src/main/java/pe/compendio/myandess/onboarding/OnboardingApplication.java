package pe.compendio.myandess.onboarding;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.time.format.DateTimeFormatter;

@SpringBootApplication(exclude= {SecurityAutoConfiguration.class})
public class OnboardingApplication {

	public static void main(String[] args) {
		SpringApplication.run(OnboardingApplication.class, args);
	}

  @Bean
  public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
      @Override
      public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedMethods("GET", "POST", "OPTIONS", "PUT")
                .exposedHeaders("Content-Disposition")
                .allowedOrigins("*");
                //.allowedOrigins("https://mvcompendiotest.southcentralus.cloudapp.azure.com");
      }
    };
  }

  @Bean
  public DateTimeFormatter dateTimeFormatter(){
    return DateTimeFormatter.ofPattern("dd/MM/yyyy");
  }
}
