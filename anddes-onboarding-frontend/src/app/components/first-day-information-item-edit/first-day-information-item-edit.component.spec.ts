import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FirstDayInformationItemEditComponent } from './first-day-information-item-edit.component';

describe('FirstDayInformationItemEditComponent', () => {
  let component: FirstDayInformationItemEditComponent;
  let fixture: ComponentFixture<FirstDayInformationItemEditComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FirstDayInformationItemEditComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FirstDayInformationItemEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
