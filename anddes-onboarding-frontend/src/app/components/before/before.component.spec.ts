import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BeforeComponent } from './before.component';

describe('BeforeComponent', () => {
  let component: BeforeComponent;
  let fixture: ComponentFixture<BeforeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BeforeComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(BeforeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
