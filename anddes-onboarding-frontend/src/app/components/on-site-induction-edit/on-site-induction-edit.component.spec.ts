import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OnSiteInductionEditComponent } from './on-site-induction-edit.component';

describe('OnSiteInductionEditComponent', () => {
  let component: OnSiteInductionEditComponent;
  let fixture: ComponentFixture<OnSiteInductionEditComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OnSiteInductionEditComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OnSiteInductionEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
