package pe.compendio.myandess.onboarding.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.oauth2.jose.jws.SignatureAlgorithm;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Value("${spring.security.oauth2.resourceserver.jwt.jwk-set-uri}")
  private String issuerUri;

  protected SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

    http.headers().httpStrictTransportSecurity().disable();
    http
      .csrf().disable()
      .sessionManagement()
      .and()
      .authorizeHttpRequests()
      .requestMatchers("/files/public/**")
      .permitAll() // permit all requests to /files/public/**
      .requestMatchers("/**").authenticated() // authenticate all requests to /**
      .anyRequest().authenticated()
      .and()
      .oauth2ResourceServer()
      .jwt()
      .decoder(jwtDecoder());
    return http.build();
  }

  @Bean
  public JwtDecoder jwtDecoder() {
    JwtDecoder jwtDecoder = NimbusJwtDecoder
                            .withJwkSetUri(issuerUri)
                            .jwsAlgorithm(SignatureAlgorithm.RS256)
                            .build();
    return new JwtDecoder() {
      @Override
      public Jwt decode(String token) throws JwtException {
        return jwtDecoder.decode(token);
      }
    };
  }
  List<String> publicApis = List.of("files/public/**","v3/api-docs/**","swagger-ui/**");
  @Bean
  public WebSecurityCustomizer webSecurityCustomizer() {
    return (web) -> web.ignoring().requestMatchers(publicApis.toArray(String[]::new));
  }

}
