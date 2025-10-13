package pe.compendio.myandess.onboarding.template;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class TemplateParamsBuilder {

    public static final String EMPLOYEE_NAME_KEY = "$nombre_del_colaborador";
    public static final String START_DATE_ONBOARDING_KEY = "$fecha_inicio";
    public static final String END_DATE_ONBOARDING_KEY = "$fecha_fin";
    public static final String ADDRESS_KEY = "$direccion";
    public static final String TOTAL_COURSES_KEY = "$cantidad_cursos_total";
    public static final String TOTAL_COURSES_COMPLETED_KEY = "$cantidad_cursos_completados";
    public static final String PROFILE_PHOTO_KEY = "$profile_photo";
    public static final String PROFILE_NAME_KEY = "$profile_name";
    public static final String PROFILE_POSITION_KEY = "$profile_position";
    public static final String EMAIL_CONTENT_KEY = "$email_content";

    private String employeeName;
    private String startDateOnboarding;
    private String endDateOnboarding;
    private String address;
    private String totalCourses;
    private String totalCoursesCompleted;
    private String profilePhoto;
    private String profileName;
    private String profilePosition;

    public TemplateParamsBuilder setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
        return this;
    }

    public TemplateParamsBuilder setStartDateOnboarding(String startDateOnboarding) {
        this.startDateOnboarding = startDateOnboarding;
        return this;
    }

    public TemplateParamsBuilder setEndDateOnboarding(String endDateOnboarding) {
        this.endDateOnboarding = endDateOnboarding;
        return this;
    }

    public TemplateParamsBuilder setAddress(String address) {
        this.address = address;
        return this;
    }

    public TemplateParamsBuilder setTotalCourses(String totalCourses) {
        this.totalCourses = totalCourses;
        return this;
    }

    public TemplateParamsBuilder setTotalCoursesCompleted(String totalCoursesCompleted) {
        this.totalCoursesCompleted = totalCoursesCompleted;
        return this;
    }

    public TemplateParamsBuilder setProfilePhoto(String profilePhoto) {
        this.profilePhoto = profilePhoto;
        return this;
    }

    public TemplateParamsBuilder setProfileName(String profileName) {
        this.profileName = profileName;
        return this;
    }

    public TemplateParamsBuilder setProfilePosition(String profilePosition) {
        this.profilePosition = profilePosition;
        return this;
    }

    public Map<String, String> build() {
        Map<String, String> params = new HashMap<>();
        if (Objects.nonNull(this.employeeName)) params.put(EMPLOYEE_NAME_KEY, this.employeeName);
        if (Objects.nonNull(this.startDateOnboarding)) params.put(START_DATE_ONBOARDING_KEY, this.startDateOnboarding);
        if (Objects.nonNull(this.endDateOnboarding)) params.put(END_DATE_ONBOARDING_KEY, this.endDateOnboarding);
        if (Objects.nonNull(this.address)) params.put(ADDRESS_KEY, this.address);
        if (Objects.nonNull(this.totalCoursesCompleted))
            params.put(TOTAL_COURSES_COMPLETED_KEY, this.totalCoursesCompleted);
        if (Objects.nonNull(this.totalCourses)) params.put(TOTAL_COURSES_KEY, this.totalCourses);
        if (Objects.nonNull(this.profilePhoto)) params.put(PROFILE_PHOTO_KEY, this.profilePhoto);
        if (Objects.nonNull(this.profileName)) params.put(PROFILE_NAME_KEY, this.profileName);
        if (Objects.nonNull(this.profilePosition)) params.put(PROFILE_POSITION_KEY, this.profilePosition);

        return params;
    }
}

