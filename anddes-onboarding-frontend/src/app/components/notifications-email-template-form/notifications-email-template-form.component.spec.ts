import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NotificationsEmailTemplateFormComponent } from './notifications-email-template-form.component';

describe('NotificationsEmailTemplateFormComponent', () => {
  let component: NotificationsEmailTemplateFormComponent;
  let fixture: ComponentFixture<NotificationsEmailTemplateFormComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NotificationsEmailTemplateFormComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(NotificationsEmailTemplateFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
